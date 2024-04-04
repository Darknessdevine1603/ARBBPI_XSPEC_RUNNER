<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pidx="http://www.pidx.org/schemas/v1.61"
   exclude-result-prefixes="#all">
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
   <!--<xsl:variable name="cXMLPIDXLookupList" select="document('LOOKUP_PIDX_1.61.xml')"/>-->  
   <!-- for dynamic, reading from Partner Directory -->
   <xsl:variable name="cXMLPIDXLookupList"
      select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
   <xsl:variable name="docLang">
      <xsl:choose>
         <xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode">
            <xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'en'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="HCur"
      select="pidx:Invoice/pidx:InvoiceProperties/pidx:PrimaryCurrency/pidx:CurrencyCode"/>
   <xsl:variable name="HCurAlt"
      select="pidx:Invoice/pidx:InvoiceProperties/pidx:SecondCurrency/pidx:CurrencyCode"/>
   <xsl:variable name="purpose" select="pidx:Invoice/pidx:InvoiceProperties/pidx:InvoiceTypeCode"/>
   <xsl:variable name="invType">
      <xsl:choose>
         <xsl:when
            test="lower-case($purpose) = 'creditmemo' and (normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber) != '' or normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber) != '' or normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(@referenceInformationIndicator) = 'contractnumber']/pidx:ReferenceNumber) != '')">
            <xsl:text>lineLevelCreditMemo</xsl:text>
         </xsl:when>
         <xsl:when test="lower-case($purpose) = 'creditmemo'">
            <xsl:text>creditMemo</xsl:text>
         </xsl:when>
         <!--xsl:when				test="lower-case($purpose) = 'debitmemo' and (normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber) != '' or normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber) != '' or normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(@referenceInformationIndicator) = 'contractnumber']/pidx:ReferenceNumber) != '')">				<xsl:text>lineLevelDebitMemo</xsl:text>			</xsl:when>			<xsl:when test="lower-case($purpose) = 'debitmemo'">				<xsl:text>debitMemo</xsl:text>			</xsl:when-->
         <xsl:when
            test="$cXMLPIDXLookupList/Lookups/InvoiceTypes/InvoiceTypes[PIDXCode = $purpose]/CXMLCode != ''">
            <xsl:value-of
               select="$cXMLPIDXLookupList/Lookups/InvoiceTypes/InvoiceType[PIDXCode = $purpose]/CXMLCode"
            />
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>standard</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="isCreditMemo">
      <xsl:choose>
         <xsl:when test="$invType = 'lineLevelCreditMemo'">yes</xsl:when>
         <xsl:when test="$invType = 'creditMemo'">yes</xsl:when>
         <xsl:otherwise>no</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="isLinePriceAdjustment">
      <xsl:choose>
         <xsl:when
            test="($invType = 'lineLevelCreditMemo' or $invType = 'lineLevelDebitMemo') and lower-case((pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:Pricing/pidx:PriceReason)[1]) = 'adjustment'">
            <xsl:text>yes</xsl:text>
         </xsl:when>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="isHeaderInvoice">
      <!--xsl:choose>			<xsl:when				test="$invType = 'creditMemo' or $invType = 'debitMemo' or ($invType = 'standard' and //pidx:InvoiceDetails/pidx:InvoiceLineItem[1]/pidx:InvoiceQuantity[pidx:UnitOfMeasureCode = 'ZZ']/pidx:Quantity = '1')">				<xsl:text>yes</xsl:text>			</xsl:when>			<xsl:otherwise/>		</xsl:choose-->
      <xsl:choose>
         <xsl:when test="$invType = 'creditMemo'">
            <xsl:text>yes</xsl:text>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:variable>
   <xsl:template match="/">
      <cXML>
         <xsl:attribute name="timestamp">
            <xsl:value-of
               select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
            />
         </xsl:attribute>
         <xsl:attribute name="payloadID">
            <xsl:value-of select="concat($anPayloadID, $anMaskANID, $anBuyerANID)"/>
            <!--xsl:value-of select="$anPayloadID"/-->
         </xsl:attribute>
         <Header>
            <xsl:variable name="ToDUNSValue">
               <xsl:choose>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="FromDUNSValue">
               <xsl:choose>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']"
                     />
                  </xsl:when>
                  <xsl:when
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber']">
                     <xsl:value-of
                        select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number']"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <!-- IG-1261 -->
            <!--xsl:variable name="systemID">					<xsl:choose>						<xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description,' ',''))='billtopurchasergroup']/pidx:ReferenceNumber!=''">							<xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description,' ',''))='billtopurchasergroup']/pidx:ReferenceNumber"/>						</xsl:when>					</xsl:choose>				</xsl:variable-->
            <From>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anSupplierANID"/>
                  </Identity>
               </Credential>
               <xsl:if test="$FromDUNSValue != ''">
                  <Credential domain="DUNS">
                     <Identity>
                        <xsl:value-of select="$FromDUNSValue"/>
                     </Identity>
                  </Credential>
               </xsl:if>
            </From>
            <To>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anBuyerANID"/>
                  </Identity>
               </Credential>
               <xsl:if test="$ToDUNSValue != ''">
                  <Credential domain="DUNS">
                     <Identity>
                        <xsl:value-of select="$ToDUNSValue"/>
                     </Identity>
                  </Credential>
               </xsl:if>
               <!-- IG-1261 -->
               <!--xsl:if test="$systemID!=''">						<Credential domain="SYSTEMID">							<Identity>								<xsl:value-of select="$systemID"/>							</Identity>						</Credential>					</xsl:if-->
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
            <InvoiceDetailRequest>
               <InvoiceDetailRequestHeader>
                  <xsl:attribute name="invoiceID">
                     <xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:InvoiceNumber"/>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceDate">
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="pidx:Invoice/pidx:InvoiceProperties/pidx:InvoiceDate"/>
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:variable name="operation"
                        select="pidx:Invoice/@pidx:transactionPurposeIndicator"/>
                     <xsl:choose>
                        <xsl:when
                           test="$cXMLPIDXLookupList/Lookups/TransactionPurposeIndicators/TransactionPurposeIndicator[PIDXCode = $operation]/CXMLCode != ''">
                           <xsl:value-of
                              select="$cXMLPIDXLookupList/Lookups/TransactionPurposeIndicators/TransactionPurposeIndicator[PIDXCode = $operation]/CXMLCode"
                           />
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>new</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="purpose">
                     <xsl:value-of select="$invType"/>
                  </xsl:attribute>
                  <InvoiceDetailHeaderIndicator>
                     <xsl:if test="$isHeaderInvoice = 'yes'">
                        <xsl:attribute name="isHeaderInvoice">
                           <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                     </xsl:if>
                  </InvoiceDetailHeaderIndicator>
                  <InvoiceDetailLineIndicator>
                     <xsl:if
                        test="count(pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax']) &gt; 0 and $isHeaderInvoice != 'yes'">
                        <xsl:attribute name="isTaxInLine">
                           <xsl:text>yes</xsl:text>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="
                           pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty'] and
                           pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
                        <xsl:attribute name="isShippingInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber'] or pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter'] or pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:ReferenceInformation[@referenceInformationIndicator = 'OperatorGeneralLedgerCode']">
                        <xsl:attribute name="isAccountingInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if test="$isLinePriceAdjustment != ''">
                        <xsl:attribute name="isPriceAdjustmentInLine">yes</xsl:attribute>
                     </xsl:if>
                  </InvoiceDetailLineIndicator>
                  <xsl:for-each
                     select="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator != 'ShipFromParty' and @partnerRoleIndicator != 'ShipToParty']">
                     <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                     <xsl:variable name="lookupRole"
                        select="($cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode)[1]"/>
                     <xsl:variable name="getPartyrole">
                        <xsl:choose>
                           <xsl:when test="@definitionOfOther = 'ReceivingFinancialInstitution'">
                              <xsl:value-of select="'wireReceivingBank'"/>
                           </xsl:when>
                           <xsl:when test="@definitionOfOther = 'Requester'">
                              <xsl:value-of select="'requester'"/>
                           </xsl:when>
                           <xsl:when
                              test="contains('|supplierAccount|supplierMasterAccount|', $lookupRole) and $lookupRole != ''">
                              <xsl:value-of select="'from'"/>
                           </xsl:when>
                           <xsl:when test="$lookupRole = 'sales'">
                              <xsl:value-of select="'issuerOfInvoice'"/>
                           </xsl:when>
                           <xsl:when test="$lookupRole != ''">
                              <xsl:value-of select="$lookupRole"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>Not Found</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="addressID">
                        <xsl:choose>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                              <xsl:value-of
                                 select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                              />
                           </xsl:when>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                              <xsl:value-of
                                 select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                              />
                           </xsl:when>
                           <xsl:otherwise/>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="addressIDDomain">
                        <xsl:choose>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                              <xsl:value-of select="'assignedByBuyer'"/>
                           </xsl:when>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                              <xsl:value-of select="'assignedBySeller'"/>
                           </xsl:when>
                           <xsl:otherwise/>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:if
                        test="$getPartyrole != 'Not Found' and $getPartyrole != 'wireReceivingBank'">
                        <InvoicePartner>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="$addressID"/>
                              </xsl:attribute>
                              <xsl:if test="$addressIDDomain != ''">
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="$addressIDDomain"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                                 <xsl:with-param name="partyRole" select="$getPartyrole"/>
                              </xsl:call-template>
                           </Contact>
                           <xsl:if test="$getPartyrole = 'requester'">
                              <xsl:for-each select=".[@definitionOfOther = 'Requester']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='Other' and @definitionOfOther = 'CreditorReferenceNumber']">                                 
                                 <IdReference>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    <xsl:attribute name="domain">creditorRefID</xsl:attribute>
                                 </IdReference>
                              </xsl:for-each>
                           </xsl:if>
                        </InvoicePartner>
                     </xsl:if>
                     <xsl:if test="$getPartyrole = 'wireReceivingBank'">
                        <InvoicePartner>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <Name>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$docLang"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="./pidx:PartnerName"/>
                              </Name>
                           </Contact>
                           <xsl:if
                              test="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'Other'][@definitionOfOther = 'AccountType']) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">accountType</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'Other'][@definitionOfOther = 'AccountType'])"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(pidx:AccountInformation/pidx:AccountHolderName) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">accountName</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(pidx:AccountInformation/pidx:AccountHolderName)"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(pidx:AccountInformation/pidx:AccountNumber) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">accountID</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(pidx:AccountInformation/pidx:AccountNumber)"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!--xsl:if test="normalize-space(pidx:AccountInformation/pidx:AccountNumber)!=''">										<IdReference>											<xsl:attribute name="domain">accountID</xsl:attribute>											<xsl:attribute name="identifier">												<xsl:value-of select="normalize-space(pidx:AccountInformation/pidx:AccountNumber)"/>											</xsl:attribute>										</IdReference>									</xsl:if-->
                           <xsl:if
                              test="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'IBAN']/pidx:ReferenceNumber) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">ibanID</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'IBAN']/pidx:ReferenceNumber)"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'SWIFT-Code']/pidx:ReferenceNumber) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">swiftID</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'SWIFT-Code']/pidx:ReferenceNumber)"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'BankRoutingID']/pidx:ReferenceNumber) != ''">
                              <IdReference>
                                 <xsl:attribute name="domain">bankRoutingID</xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of
                                       select="normalize-space(../pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'BankRoutingID']/pidx:ReferenceNumber)"
                                    />
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                        </InvoicePartner>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if
                     test="$isCreditMemo = 'yes' and pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(@referenceInformationIndicator) = 'originalinvoicenumber']/pidx:ReferenceNumber != ''">
                     <InvoiceIDInfo>
                        <xsl:attribute name="invoiceID">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(@referenceInformationIndicator) = 'originalinvoicenumber']/pidx:ReferenceNumber"
                           />
                        </xsl:attribute>
                        <xsl:variable name="invDate"
                           select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(@referenceInformationIndicator) = 'originalinvoicenumber']/pidx:Description"/>
                        <xsl:if
                           test="$invDate castable as xs:date or $invDate castable as xs:dateTime">
                           <xsl:attribute name="invoiceDate">
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate" select="$invDate"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                     </InvoiceIDInfo>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'paymentproposalnumber']/pidx:ReferenceNumber">
                     <PaymentProposalIDInfo>
                        <xsl:attribute name="paymentProposalID">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'paymentproposalnumber']/pidx:ReferenceNumber"
                           />
                        </xsl:attribute>
                     </PaymentProposalIDInfo>
                  </xsl:if>
                  <!--<xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty'] and pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']">
                     <InvoiceDetailShipping>
                        <xsl:if
                           test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment']) != ''">
                           <xsl:attribute name="shippingDate">
                              <xsl:value-of
                                 select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment'])"
                              />
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each
                           select="
                              pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator
                              = 'ShipFromParty' or @partnerRoleIndicator = 'ShipToParty' or
                              @partnerRoleIndicator = 'Carrier']">
                           <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                           <xsl:variable name="getPartyrole"
                              select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                           <xsl:variable name="addressID">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                    />
                                 </xsl:when>
                                 <xsl:otherwise/>
                              </xsl:choose>
                           </xsl:variable>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="$addressID"/>
                              </xsl:attribute>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                              </xsl:call-template>
                           </Contact>
                        </xsl:for-each>
                     </InvoiceDetailShipping>
                  </xsl:if>-->
                  
                  <!-- IG-29733 -->
                  <xsl:choose>
                     <xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty'] and pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']">
                           <InvoiceDetailShipping>
                              <xsl:if
                                 test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment']) != ''">
                                 <xsl:attribute name="shippingDate">
                                    <xsl:value-of
                                       select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment'])"
                                    />
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:for-each
                                 select="
                                 pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator
                                 = 'ShipFromParty' or @partnerRoleIndicator = 'ShipToParty' or
                                 @partnerRoleIndicator = 'Carrier']">
                                 <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                                 <xsl:variable name="getPartyrole"
                                    select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                                 <xsl:variable name="addressID">
                                    <xsl:choose>
                                       <xsl:when
                                          test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                          <xsl:value-of
                                             select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                          />
                                       </xsl:when>
                                       <xsl:when
                                          test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                          <xsl:value-of
                                             select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                          />
                                       </xsl:when>
                                       <xsl:otherwise/>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <Contact>
                                    <xsl:attribute name="role">
                                       <xsl:value-of select="$getPartyrole"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressID">
                                       <xsl:value-of select="$addressID"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="CreateContact">
                                       <xsl:with-param name="partyInfo" select="."/>
                                    </xsl:call-template>
                                 </Contact>
                              </xsl:for-each>
                           </InvoiceDetailShipping>                        
                     </xsl:when>
                     <xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']">
                        <InvoiceDetailShipping>
                           <xsl:if
                              test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment']) != ''">
                              <xsl:attribute name="shippingDate">
                                 <xsl:value-of
                                    select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment'])"
                                 />
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:for-each
                              select="
                              pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty' or
                              @partnerRoleIndicator = 'Carrier']">
                              <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                              <xsl:variable name="getPartyrole"
                                 select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                              <xsl:variable name="addressID">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                       />
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                       />
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:variable>
                              <Contact>
                                 <xsl:attribute name="role">
                                    <xsl:value-of select="$getPartyrole"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="$addressID"/>
                                 </xsl:attribute>
                                 <xsl:call-template name="CreateContact">
                                    <xsl:with-param name="partyInfo" select="."/>
                                 </xsl:call-template>
                              </Contact>
                           </xsl:for-each>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'shipFrom'"/>
                              </xsl:attribute>
                              <Name xml:lang="EN"></Name>
                           </Contact>
                        </InvoiceDetailShipping>                        
                     </xsl:when>
                     <xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
                        <InvoiceDetailShipping>
                           <xsl:if
                              test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment']) != ''">
                              <xsl:attribute name="shippingDate">
                                 <xsl:value-of
                                    select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'RequestedShipment'])"
                                 />
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:for-each
                              select="
                              pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty' or
                              @partnerRoleIndicator = 'Carrier']">
                              <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                              <xsl:variable name="getPartyrole"
                                 select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                              <xsl:variable name="addressID">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                       />
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                       />
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:variable>
                              <Contact>
                                 <xsl:attribute name="role">
                                    <xsl:value-of select="$getPartyrole"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="$addressID"/>
                                 </xsl:attribute>
                                 <xsl:call-template name="CreateContact">
                                    <xsl:with-param name="partyInfo" select="."/>
                                 </xsl:call-template>
                              </Contact>
                           </xsl:for-each>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'shipTo'"/>
                              </xsl:attribute>
                              <Name xml:lang="EN"></Name>
                           </Contact>
                        </InvoiceDetailShipping>                        
                     </xsl:when>
                  </xsl:choose>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber) != ''">
                     <ShipNoticeIDInfo>
                        <xsl:if
                           test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'PromisedForShipment']) != ''">
                           <xsl:attribute name="shipNoticeDate">
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'PromisedForShipment']"
                                 />
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="shipNoticeID">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber"
                           />
                        </xsl:attribute>
                     </ShipNoticeIDInfo>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:TermsNetDays != ''">
                     <PaymentTerm>
                        <xsl:attribute name="payInNumberOfDays">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:TermsNetDays"
                           />
                        </xsl:attribute>
                        <!--xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms"/-->
                     </PaymentTerm>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DaysDue[1] != '' and pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DaysDue[1] != '0'">
                     <PaymentTerm>
                        <xsl:attribute name="payInNumberOfDays">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DaysDue[1]"
                           />
                        </xsl:attribute>
                        <xsl:if
                           test="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:PercentDiscount != '' or pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountAmount/pidx:MonetaryAmount != ''">
                           <Discount>
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:PercentDiscount != ''">
                                    <DiscountPercent>
                                       <xsl:attribute name="percent">
                                          <xsl:value-of
                                             select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:PercentDiscount"
                                          />
                                       </xsl:attribute>
                                    </DiscountPercent>
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountAmount/pidx:MonetaryAmount != ''">
                                    <DiscountAmount>
                                       <xsl:call-template name="createMoney">
                                          <xsl:with-param name="curr"
                                             select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountAmount/pidx:CurrencyCode"/>
                                          <xsl:with-param name="money"
                                             select="pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountAmount/pidx:MonetaryAmount"
                                          />
                                       </xsl:call-template>
                                    </DiscountAmount>
                                 </xsl:when>
                              </xsl:choose>
                           </Discount>
                        </xsl:if>
                        <xsl:if
                           test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountsDueDate[1]) != ''">
                           <Extrinsic>
                              <xsl:attribute name="name">discountDueDate</xsl:attribute>
                              <xsl:value-of
                                 select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Discounts/pidx:DiscountsDueDate[1])"
                              />
                           </Extrinsic>
                        </xsl:if>
                     </PaymentTerm>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart'] != '' and pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodEnd'] != ''">
                     <Period>
                        <xsl:attribute name="startDate">
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart']"
                              />
                           </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="endDate">
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodEnd']"
                              />
                           </xsl:call-template>
                        </xsl:attribute>
                     </Period>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:Comment) != '' or $cXMLAttachments != ''">
                     <Comments>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:Comment)"/>
                        <xsl:if test="$cXMLAttachments != ''">
                           <xsl:variable name="tokenizedAttachments"
                              select="tokenize($cXMLAttachments, $attachSeparator)"/>
                           <xsl:for-each select="$tokenizedAttachments">
                              <xsl:if test="normalize-space(.) != ''">
                                 <Attachment>
                                    <URL>
                                       <xsl:value-of select="."/>
                                    </URL>
                                 </Attachment>
                              </xsl:if>
                           </xsl:for-each>
                        </xsl:if>
                     </Comments>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:FieldTicketInformation != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>FieldTicketNumber</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:FieldTicketInformation/pidx:FieldTicketNumber"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>DeliveryTicketNumber</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <!-- IG-3213 -->
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellIdentifier != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>wellIdentifier</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellIdentifier"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellName != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>wellName</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellName"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellType != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>wellType</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellType"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellCategory != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>wellCategory</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:JobLocationInformation/pidx:WellInformation/pidx:WellCategory"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'CustomerReferenceNumber']/pidx:ReferenceNumber != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>customerReferenceID</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'CustomerReferenceNumber']/pidx:ReferenceNumber"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if
                     test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'CustomerReferenceNumber']/pidx:Description != ''">
                     <IdReference>
                        <xsl:attribute name="domain">
                           <xsl:text>customerReferenceDate</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of
                              select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'CustomerReferenceNumber']/pidx:Description"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <Extrinsic name="invoiceSourceDocument">
                     <xsl:choose>
                        <xsl:when
                           test="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber != ''">
                           <xsl:text>PurchaseOrder</xsl:text>
                        </xsl:when>
                        <xsl:when
                           test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber != '' and not(exists(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber)) and pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber != ''">
                           <xsl:text>SalesOrder</xsl:text>
                        </xsl:when>
                        <xsl:when
                           test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber != '' and not(exists(pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber))">
                           <xsl:text>Contract</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>NoOrderInformation</xsl:otherwise>
                     </xsl:choose>
                  </Extrinsic>
                  <xsl:element name="Extrinsic">
                     <xsl:attribute name="name">invoiceSubmissionMethod</xsl:attribute>
                     <xsl:value-of select="'CIG_PIDX'"/>
                  </xsl:element>
                  <!--xsl:if
              test="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalForm']/pidx:ReferenceNumber) != ''">
              <Extrinsic>
                <xsl:attribute name="name">LegalStatus</xsl:attribute>
                <xsl:value-of
                  select="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalForm']/pidx:ReferenceNumber)"
                />
              </Extrinsic>
            </xsl:if>
            <xsl:if
              test="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber) != ''">
              <Extrinsic>
                <xsl:attribute name="name">LegalCapital</xsl:attribute>
                <No Money Template used>
                <Money>
                  <xsl:attribute name="currency">
                    <xsl:value-of
                      select="substring-after(normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber), ' ')"
                    />
                  </xsl:attribute>
                  <xsl:value-of
                    select="substring-before(normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber), ' ')"
                  />
                </Money>
              </Extrinsic>
            </xsl:if-->
                  <!-- IG-3277 before: cXML -->
                  <!-- IG-1274 -->
                  <xsl:choose>
                     <xsl:when
                        test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:TaxInformation/pidx:TaxIdentifierNumber) != ''">
                        <Extrinsic name="supplierVatID">
                           <xsl:value-of
                              select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:TaxInformation/pidx:TaxIdentifierNumber)"
                           />
                        </Extrinsic>
                     </xsl:when>
                     <xsl:when
                        test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'RemitTo']/pidx:TaxInformation/pidx:TaxIdentifierNumber) != ''">
                        <Extrinsic name="supplierVatID">
                           <xsl:value-of
                              select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'RemitTo']/pidx:TaxInformation/pidx:TaxIdentifierNumber)"
                           />
                        </Extrinsic>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:TaxInformation/pidx:TaxIdentifierNumber) != ''">
                     <Extrinsic name="buyerVatID">
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'BillTo']/pidx:TaxInformation/pidx:TaxIdentifierNumber)"
                        />
                     </Extrinsic>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'GovernmentRegistrationNumber']/pidx:ReferenceNumber) != ''">
                     <Extrinsic>
                        <xsl:attribute name="name">supplierCommercialIdentifier</xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'GovernmentRegistrationNumber']/pidx:ReferenceNumber)"
                        />
                     </Extrinsic>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierCommercialCredentials']/pidx:ReferenceNumber) != ''">
                     <Extrinsic>
                        <xsl:attribute name="name">supplierCommercialCredentials</xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierCommercialCredentials']/pidx:ReferenceNumber)"
                        />
                     </Extrinsic>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'PromisedForDelivery']) != ''">
                     <Extrinsic>
                        <xsl:attribute name="name">deliveryDate</xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[pidx:dateTypeIndicator = 'PromisedForDelivery'])"
                        />
                     </Extrinsic>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'PaymentMethod']/pidx:ReferenceNumber) != ''">
                     <xsl:variable name="payMethod"
                        select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][pidx:Description = 'PaymentMethod']/pidx:ReferenceNumber)"/>
                     <xsl:if
                        test="$cXMLPIDXLookupList/Lookups/PaymentMethods/PaymentMethod[PIDXCode = $payMethod]/CXMLCode">
                        <Extrinsic>
                           <xsl:attribute name="name">paymentMethod</xsl:attribute>
                           <xsl:value-of
                              select="$cXMLPIDXLookupList/Lookups/PaymentMethods/PaymentMethod[PIDXCode = $payMethod]/CXMLCode"
                           />
                        </Extrinsic>
                     </xsl:if>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Description) != ''">
                     <Extrinsic>
                        <xsl:attribute name="name">paymentTermsDescription</xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:PaymentTerms/pidx:Description)"
                        />
                     </Extrinsic>
                  </xsl:if>
                  <xsl:for-each
                     select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']">
                     <xsl:if
                        test="normalize-space(pidx:Description) != '' and not(contains('GovernmentRegistrationNumber|SupplierLegalForm|SupplierLegalCapital|SupplierCommercialCredentials|TaxPointDate|IBAN|SWIFT-Code|', pidx:Description))">
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="normalize-space(pidx:Description)"/>
                           </xsl:attribute>
                           <xsl:value-of select="normalize-space(pidx:ReferenceNumber)"/>
                        </Extrinsic>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if
                     test="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ShippedDate']) != ''">
                     <Extrinsic>
                        <xsl:attribute name="name">deliveryNoteDate</xsl:attribute>
                        <xsl:value-of
                           select="normalize-space(pidx:Invoice/pidx:InvoiceProperties/pidx:ServiceDateTime[@dateTypeIndicator = 'ShippedDate'])"
                        />
                     </Extrinsic>
                  </xsl:if>
               </InvoiceDetailRequestHeader>
               <!--Line-->
               <!--Header Invoice or SummaryInvoice-->
               <xsl:choose>
                  <xsl:when test="$isHeaderInvoice = 'yes'">
                     <xsl:for-each select="pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem">
                        <InvoiceDetailHeaderOrder>
                           <InvoiceDetailOrderInfo>
                              <OrderReference>
                                 <xsl:if
                                    test="pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber != ''">
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of
                                          select="pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber"
                                       />
                                    </xsl:attribute>
                                 </xsl:if>
                                 <DocumentReference>
                                    <xsl:attribute name="payloadID"> </xsl:attribute>
                                 </DocumentReference>
                              </OrderReference>
                              <xsl:if
                                 test="pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber != ''">
                                 <MasterAgreementReference>
                                    <xsl:attribute name="agreementID">
                                       <xsl:value-of
                                          select="pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber"
                                       />
                                    </xsl:attribute>
                                    <xsl:if
                                       test="pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:Description = '1'">
                                       <xsl:attribute name="agreementType">
                                          <xsl:value-of select="'scheduling_agreement'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <DocumentReference>
                                       <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                 </MasterAgreementReference>
                              </xsl:if>
                              <xsl:if
                                 test="pidx:PurchaseOrderInformation/pidx:SalesOrderNumber != ''">
                                 <SupplierOrderInfo>
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of
                                          select="pidx:PurchaseOrderInformation/pidx:SalesOrderNumber"
                                       />
                                    </xsl:attribute>
                                 </SupplierOrderInfo>
                              </xsl:if>
                           </InvoiceDetailOrderInfo>
                           <xsl:call-template name="createHeaderInvoiceItem">
                              <xsl:with-param name="item" select="."/>
                           </xsl:call-template>
                        </InvoiceDetailHeaderOrder>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <InvoiceDetailOrder>
                        <InvoiceDetailOrderInfo>
                           <xsl:if
                              test="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber != '' or pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber != '' or pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber != ''">
                              <xsl:if
                                 test="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber != ''">
                                 <OrderReference>
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of
                                          select="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber"
                                       />
                                    </xsl:attribute>
                                    <DocumentReference>
                                       <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                 </OrderReference>
                              </xsl:if>
                              <xsl:if
                                 test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber != ''">
                                 <MasterAgreementReference>
                                    <xsl:attribute name="agreementID">
                                       <xsl:value-of
                                          select="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:ReferenceNumber"
                                       />
                                    </xsl:attribute>
                                    <xsl:if
                                       test="pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'ContractNumber']/pidx:Description = '1'">
                                       <xsl:attribute name="agreementType">
                                          <xsl:value-of select="'scheduling_agreement'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <DocumentReference>
                                       <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                 </MasterAgreementReference>
                              </xsl:if>
                              <xsl:if
                                 test="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber != ''">
                                 <SupplierOrderInfo>
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of
                                          select="pidx:Invoice/pidx:InvoiceProperties/pidx:PurchaseOrderInformation/pidx:SalesOrderNumber"
                                       />
                                    </xsl:attribute>
                                 </SupplierOrderInfo>
                              </xsl:if>
                           </xsl:if>
                        </InvoiceDetailOrderInfo>
                        <xsl:variable name="AnyHighPartNumber"
                           select="count(pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:Description = 'High'])"/>
                        <xsl:variable name="AnyLowPartNumber"
                           select="count(pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:Description = 'Low'])"/>
                        <xsl:choose>
                           <xsl:when test="$AnyHighPartNumber &gt; 0 and $AnyLowPartNumber &gt; 0">
                              <xsl:for-each
                                 select="pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem">
                                 <xsl:variable name="LineItemNumber" select="pidx:LineItemNumber"/>
                                 <xsl:variable name="HighOrLow"
                                    select="pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:Description"/>
                                 <xsl:choose>
                                    <xsl:when test="$HighOrLow = 'High'">
                                       <xsl:variable name="HighPartNumberSeller"
                                          select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedBySeller']"/>
                                       <xsl:variable name="HighPartNumberBuyer"
                                          select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedByBuyer']"/>
                                       <xsl:variable name="ParentLineItemNumber"
                                          select="pidx:LineItemNumber"/>
                                       <xsl:variable name="HasALow"
                                          select="count(//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ParentLineItemNumber])"/>
                                       <xsl:choose>
                                          <xsl:when test="$HasALow &gt; 0">
                                             <!-- Loop over each Child element of the current Parent/High line item -->
                                             <xsl:for-each
                                                select="//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ParentLineItemNumber]">
                                                <xsl:variable name="ChildReference1"
                                                  select="pidx:LineItemNumber"/>
                                                <xsl:variable name="LowPartNumber1"
                                                  select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedBySeller']"/>
                                                <xsl:variable name="Child2Count"
                                                  select="count(//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ChildReference1])"/>
                                                <xsl:choose>
                                                  <xsl:when test="$Child2Count &gt; 0">
                                                  <!-- Loop over each Child element of the current Child  (This is Grand Child of the "High" Parent -->
                                                  <xsl:for-each
                                                  select="//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ChildReference1]">
                                                  <xsl:variable name="ChildReference2"
                                                  select="pidx:LineItemNumber"/>
                                                  <xsl:variable name="LowPartNumber2"
                                                  select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedBySeller']"/>
                                                  <xsl:variable name="Child3Count"
                                                  select="count(//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ChildReference2])"/>
                                                  <xsl:choose>
                                                  <xsl:when test="$Child3Count &gt; 0">
                                                  <!-- Loop over each Child element of the 2nd Child (This is Great Crand Child of the "HIgh" Parent  -->
                                                  <xsl:for-each
                                                  select="//pidx:InvoiceLineItem[pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber = $ChildReference2]">
                                                  <xsl:variable name="LowPartNumber3"
                                                  select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedBySeller']"/>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                                  <InvoiceDetailItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType" select="'goods'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="concat($LowPartNumber1, '+', $LowPartNumber2, '+', $LowPartNumber3)"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailItem>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <InvoiceDetailServiceItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType"
                                                  select="'services'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="concat($LowPartNumber1, '+', $LowPartNumber2, '+', $LowPartNumber3)"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailServiceItem>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                                  <InvoiceDetailItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType" select="'goods'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="concat($LowPartNumber1, '+', $LowPartNumber2)"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailItem>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <InvoiceDetailServiceItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType"
                                                  select="'services'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="concat($LowPartNumber1, '+', $LowPartNumber2)"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailServiceItem>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <!-- This is the Child of the "High" parent, and this child has no children -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                                  <InvoiceDetailItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType" select="'goods'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="$LowPartNumber1"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailItem>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <InvoiceDetailServiceItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType"
                                                  select="'services'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="LowPartNum"
                                                  select="$LowPartNumber1"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailServiceItem>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:for-each>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <!--Only High without any corresponding Low items -->
                                             <xsl:choose>
                                                <xsl:when
                                                  test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                                  <InvoiceDetailItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType" select="'goods'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailItem>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <InvoiceDetailServiceItem>
                                                  <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType"
                                                  select="'services'"/>
                                                  <xsl:with-param name="HighPartNum"
                                                  select="$HighPartNumberSeller"/>
                                                  <xsl:with-param name="BuyerPartNum"
                                                  select="$HighPartNumberBuyer"/>
                                                  </xsl:call-template>
                                                  </InvoiceDetailServiceItem>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="$HighOrLow = 'Low'"/>
                                    <xsl:otherwise>
                                       <xsl:choose>
                                          <xsl:when
                                             test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                             <InvoiceDetailItem>
                                                <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType" select="'goods'"/>
                                                </xsl:call-template>
                                             </InvoiceDetailItem>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <InvoiceDetailServiceItem>
                                                <xsl:call-template name="createInvoiceDetailItem">
                                                  <xsl:with-param name="item" select="."/>
                                                  <xsl:with-param name="itemType"
                                                  select="'services'"/>
                                                </xsl:call-template>
                                             </InvoiceDetailServiceItem>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:for-each
                                 select="pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem">
                                 <xsl:choose>
                                    <xsl:when
                                       test="lower-case(pidx:CommodityCode[@agencyIndicator = 'AssignedByBuyer']) = 'goods'">
                                       <InvoiceDetailItem>
                                          <xsl:call-template name="createInvoiceDetailItem">
                                             <xsl:with-param name="item" select="."/>
                                             <xsl:with-param name="itemType" select="'goods'"/>
                                          </xsl:call-template>
                                       </InvoiceDetailItem>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <InvoiceDetailServiceItem>
                                          <xsl:call-template name="createInvoiceDetailItem">
                                             <xsl:with-param name="item" select="."/>
                                             <xsl:with-param name="itemType" select="'services'"/>
                                          </xsl:call-template>
                                       </InvoiceDetailServiceItem>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:otherwise>
                        </xsl:choose>
                     </InvoiceDetailOrder>
                  </xsl:otherwise>
               </xsl:choose>
               <InvoiceDetailSummary>
                  <SubtotalAmount>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:SubTotalAmount[@subTotalIndicator = 'Other']/pidx:CurrencyCode"/>
                        <xsl:with-param name="money"
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:SubTotalAmount[@subTotalIndicator = 'Other']/pidx:MonetaryAmount"
                        />
                     </xsl:call-template>
                  </SubtotalAmount>
                  <Tax>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                           select="(pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax'])[1]/pidx:TaxAmount/pidx:CurrencyCode"/>
                        <xsl:with-param name="money"
                           select="(pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax'])[1]/pidx:TaxAmount/pidx:MonetaryAmount"
                        />
                     </xsl:call-template>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:text>Summary Tax</xsl:text>
                     </Description>
                     <xsl:for-each
                        select="pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax']">
                        <TaxDetail>
                           <xsl:attribute name="category">
                              <xsl:variable name="category" select="pidx:TaxTypeCode"/>
                              <xsl:value-of
                                 select="$cXMLPIDXLookupList/Lookups/TaxTypes/TaxType[PIDXCode = $category]/CXMLCode"
                              />
                           </xsl:attribute>
                           <xsl:if test="pidx:TaxLocation/pidx:LocationDescription">
                              <xsl:attribute name="isTriangularTransaction">
                                 <xsl:text>yes</xsl:text>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="pidx:TaxRate != ''">
                              <xsl:attribute name="percentageRate">
                                 <xsl:value-of select="pidx:TaxRate"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="pidx:TaxReference != ''">
                              <xsl:attribute name="taxPointDate">
                                 <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate"
                                       select="normalize-space(pidx:TaxReference)"
                                    />
                                 </xsl:call-template>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:choose>
                              <!-- IG-26422 Zero Rated Tax -->
                              <xsl:when test="number(pidx:TaxRate) = 0 and (pidx:TaxTypeCode = 'ValueAddedTax' or pidx:TaxTypeCode = 'GoodsAndServicesTax')">
                                 <xsl:attribute name="exemptDetail">
                                    <xsl:text>zeroRated</xsl:text>
                                 </xsl:attribute>
                              </xsl:when>
                              <xsl:when test="pidx:TaxExemptCode = 'Exampt' or pidx:TaxExemptCode = 'Exempt'">
                                 <xsl:attribute name="exemptDetail">
                                    <xsl:text>exempt</xsl:text>
                                 </xsl:attribute>
                              </xsl:when>
                           </xsl:choose>
                           <xsl:if test="pidx:TaxBasisAmount">
                              <TaxableAmount>
                                 <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                       select="pidx:TaxBasisAmount/pidx:CurrencyCode"/>
                                    <xsl:with-param name="money"
                                       select="pidx:TaxBasisAmount/pidx:MonetaryAmount"/>
                                 </xsl:call-template>
                              </TaxableAmount>
                           </xsl:if>
                           <TaxAmount>
                              <xsl:call-template name="createMoney">
                                 <xsl:with-param name="curr"
                                    select="pidx:TaxAmount/pidx:CurrencyCode"/>
                                 <xsl:with-param name="money"
                                    select="pidx:TaxAmount/pidx:MonetaryAmount"/>
                              </xsl:call-template>
                           </TaxAmount>
                           <xsl:if test="pidx:TaxLocation/pidx:LocationName != ''">
                              <TaxLocation>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$docLang"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="pidx:TaxLocation/pidx:LocationName"/>
                              </TaxLocation>
                           </xsl:if>
                           <!-- IG-26422 Zero Rated Tax -->
                           <xsl:if test="number(pidx:TaxRate) = 0 and (pidx:TaxTypeCode = 'ValueAddedTax' or pidx:TaxTypeCode = 'GoodsAndServicesTax')">
                              <Description xml:lang="en">
                                 <xsl:text>Zero rated tax</xsl:text>
                              </Description>
                           </xsl:if>
                           <xsl:if test="pidx:TaxLocation/pidx:LocationDescription != ''">
                              <TriangularTransactionLawReference>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$docLang"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="pidx:TaxLocation/pidx:LocationDescription"/>
                              </TriangularTransactionLawReference>
                           </xsl:if>
                           <xsl:if test="pidx:TaxExemptCode = 'NonExempt'">
                              <Extrinsic>
                                 <xsl:attribute name="name">
                                    <xsl:text>exemptType</xsl:text>
                                 </xsl:attribute>
                                 <xsl:text>Standard</xsl:text>
                              </Extrinsic>
                           </xsl:if>
                        </TaxDetail>
                     </xsl:for-each>
                  </Tax>
                  <!--xsl:choose>							<xsl:when test="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:MonetaryAmount != ''">								<ShippingAmount>									<xsl:call-template name="createMoney">										<xsl:with-param name="curr" select="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:CurrencyCode"/>										<xsl:with-param name="money" select="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:MonetaryAmount"/>									</xsl:call-template>								</ShippingAmount>							</xsl:when>							<xsl:when test="pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">								<ShippingAmount>									<xsl:call-template name="createMoney">										<xsl:with-param name="curr" select="pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>										<xsl:with-param name="money" select="pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"/>									</xsl:call-template>								</ShippingAmount>							</xsl:when>						</xsl:choose-->
                  <xsl:if
                     test="(pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge/@allowanceOrChargeIndicator = 'Allowance' or pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge/@allowanceOrChargeIndicator = 'Charge') or pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[pidx:TaxTypeCode = 'WellServiceTax']">
                     <InvoiceHeaderModifications>
                        <!--xsl:variable name="Indicator" select="@allowanceOrChargeIndicator"/-->
                        <xsl:for-each
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Allowance' or @allowanceOrChargeIndicator = 'Charge']">
                           <Modification>
                              <xsl:choose>
                                 <xsl:when test="@allowanceOrChargeIndicator = 'Allowance'">
                                    <AdditionalDeduction>
                                       <xsl:choose>
                                          <xsl:when
                                             test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                             <DeductionAmount>
                                                <xsl:call-template name="createMoney">
                                                  <xsl:with-param name="curr"
                                                  select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                                  <xsl:with-param name="money"
                                                  select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                                  />
                                                </xsl:call-template>
                                             </DeductionAmount>
                                          </xsl:when>
                                          <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                             <DeductionPercent>
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of
                                                  select="pidx:AllowanceOrChargePercent"/>
                                                </xsl:attribute>
                                             </DeductionPercent>
                                          </xsl:when>
                                       </xsl:choose>
                                    </AdditionalDeduction>
                                 </xsl:when>
                                 <xsl:when test="@allowanceOrChargeIndicator = 'Charge'">
                                    <AdditionalCost>
                                       <xsl:choose>
                                          <xsl:when
                                             test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                             <xsl:call-template name="createMoney">
                                                <xsl:with-param name="curr"
                                                  select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                                <xsl:with-param name="money"
                                                  select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                                />
                                             </xsl:call-template>
                                          </xsl:when>
                                          <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                             <Percentage>
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of
                                                  select="pidx:AllowanceOrChargePercent"/>
                                                </xsl:attribute>
                                             </Percentage>
                                          </xsl:when>
                                       </xsl:choose>
                                    </AdditionalCost>
                                 </xsl:when>
                              </xsl:choose>
                              <ModificationDetail>
                                 <xsl:variable name="ModName"
                                    select="pidx:AllowanceOrChargeTypeCode"/>
                                 <xsl:attribute name="name">
                                    <xsl:value-of
                                       select="$cXMLPIDXLookupList/Lookups/AllowanceOrChargeTypeCodes/AllowanceOrChargeTypeCode[PIDXCode = $ModName]/CXMLCode"
                                    />
                                 </xsl:attribute>
                                 <xsl:if
                                    test="pidx:MethodOfHandlingCode != '' and pidx:MethodOfHandlingCode != 'Other'">
                                    <xsl:variable name="MCode" select="pidx:MethodOfHandlingCode"/>
                                    <xsl:attribute name="code">
                                       <xsl:value-of
                                          select="$cXMLPIDXLookupList/Lookups/MethodOfHandlingCodes/MethodOfHandlingCode[PIDXCode = $MCode]/CXMLCode"
                                       />
                                    </xsl:attribute>
                                 </xsl:if>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$docLang"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="pidx:AllowanceOrChargeDescription"/>
                                 </Description>
                              </ModificationDetail>
                           </Modification>
                        </xsl:for-each>
                        <xsl:if
                           test="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:MonetaryAmount != ''">
                           <Modification>
                              <AdditionalCost>
                                 <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                       select="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:CurrencyCode"/>
                                    <xsl:with-param name="money"
                                       select="pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount/pidx:MonetaryAmount"
                                    />
                                 </xsl:call-template>
                              </AdditionalCost>
                              <ModificationDetail>
                                 <xsl:attribute name="name">
                                    <xsl:value-of select="'Shipping'"/>
                                 </xsl:attribute>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$docLang"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="'Shipping Amount'"/>
                                 </Description>
                              </ModificationDetail>
                           </Modification>
                        </xsl:if>
                        <xsl:for-each
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[pidx:TaxTypeCode = 'WellServiceTax']">
                           <Modification>
                              <AdditionalCost>
                                 <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                       select="pidx:TaxAmount/pidx:CurrencyCode"/>
                                    <xsl:with-param name="money"
                                       select="pidx:TaxAmount/pidx:MonetaryAmount"/>
                                 </xsl:call-template>
                              </AdditionalCost>
                              <ModificationDetail>
                                 <xsl:attribute name="name">
                                    <xsl:value-of select="'Charge'"/>
                                 </xsl:attribute>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:choose>
                                          <xsl:when test="$docLang != ''">
                                             <xsl:value-of select="$docLang"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="'en'"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="pidx:TaxTypeCode"/>
                                 </Description>
                              </ModificationDetail>
                           </Modification>
                        </xsl:for-each>
                     </InvoiceHeaderModifications>
                  </xsl:if>
                  <NetAmount>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:InvoiceTotal/pidx:CurrencyCode"/>
                        <xsl:with-param name="money"
                           select="pidx:Invoice/pidx:InvoiceSummary/pidx:InvoiceTotal/pidx:MonetaryAmount"
                        />
                     </xsl:call-template>
                  </NetAmount>
               </InvoiceDetailSummary>
            </InvoiceDetailRequest>
         </Request>
      </cXML>
   </xsl:template>
   <xsl:template name="CreateContact">
      <xsl:param name="partyInfo"/>
      <xsl:param name="partyRole"/>
      <Name>
         <xsl:attribute name="xml:lang">
            <xsl:value-of select="$docLang"/>
         </xsl:attribute>
         <xsl:value-of select="$partyInfo/pidx:PartnerName"/>
      </Name>
      <PostalAddress>
         <xsl:choose>
            <xsl:when test="$partyInfo/pidx:AddressInformation/pidx:AddressLine != ''">
               <xsl:for-each select="$partyInfo/pidx:AddressInformation/pidx:AddressLine">
                  <Street>
                     <!--<xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:AddressLine"/>-->
                     <xsl:value-of select="."/>
                  </Street>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <Street> </Street>
            </xsl:otherwise>
         </xsl:choose>
         <City>
            <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:CityName"/>
         </City>
         <State>
            <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:StateProvince"/>
         </State>
         <xsl:if test="$partyInfo/pidx:AddressInformation/pidx:PostalCode != ''">
            <PostalCode>
               <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:PostalCode"/>
            </PostalCode>
         </xsl:if>
         <Country>
            <xsl:attribute name="isoCountryCode">
               <xsl:value-of
                  select="$partyInfo/pidx:AddressInformation/pidx:PostalCountry/pidx:CountryCode"/>
            </xsl:attribute>
         </Country>
      </PostalAddress>
      <xsl:if test="$partyInfo/pidx:ContactInformation">
         <xsl:for-each select="$partyInfo/pidx:ContactInformation/pidx:EmailAddress">
            <Email>
               <xsl:attribute name="name">
                  <xsl:value-of select="../@contactInformationIndicator"/>
               </xsl:attribute>
               <xsl:value-of select="."/>
            </Email>
         </xsl:for-each>
         <xsl:for-each
            select="$partyInfo/pidx:ContactInformation/pidx:Telephone[@telephoneIndicator = 'Voice']">
            <xsl:if test="pidx:PhoneNumber != ''">
               <Phone>
                  <xsl:attribute name="name">
                     <xsl:value-of select="../@contactInformationIndicator"/>
                  </xsl:attribute>
                  <TelephoneNumber>
                     <CountryCode>
                        <xsl:attribute name="isoCountryCode">
                           <xsl:value-of select="pidx:TelecomCountryCode"/>
                        </xsl:attribute>
                     </CountryCode>
                     <AreaOrCityCode>
                        <xsl:value-of select="pidx:TelecomAreaCode"/>
                     </AreaOrCityCode>
                     <Number>
                        <xsl:value-of select="pidx:PhoneNumber"/>
                     </Number>
                     <Extension/>
                  </TelephoneNumber>
               </Phone>
            </xsl:if>
         </xsl:for-each>
         <xsl:for-each
            select="$partyInfo/pidx:ContactInformation/pidx:Telephone[@telephoneIndicator = 'Fax']">
            <xsl:if test="pidx:PhoneNumber != ''">
               <Fax>
                  <xsl:attribute name="name">
                     <xsl:value-of select="../@contactInformationIndicator"/>
                  </xsl:attribute>
                  <TelephoneNumber>
                     <CountryCode>
                        <xsl:attribute name="isoCountryCode">
                           <xsl:value-of select="pidx:TelecomCountryCode"/>
                        </xsl:attribute>
                     </CountryCode>
                     <AreaOrCityCode>
                        <xsl:value-of select="pidx:TelecomAreaCode"/>
                     </AreaOrCityCode>
                     <Number>
                        <xsl:value-of select="pidx:PhoneNumber"/>
                     </Number>
                     <Extension/>
                  </TelephoneNumber>
               </Fax>
            </xsl:if>
         </xsl:for-each>
      </xsl:if>
      <xsl:for-each
         select="$partyInfo/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller' or @partnerIdentifierIndicator = 'DUNS+4Number' or @partnerIdentifierIndicator = 'DUNSNumber']">
         <xsl:variable name="IdRef" select="@partnerIdentifierIndicator"/>
         <xsl:variable name="domain"
            select="$cXMLPIDXLookupList/Lookups/IDReferences/IDReference[PIDXCode = $IdRef]/CXMLCode"/>
         <xsl:choose>
            <xsl:when
               test="$IdRef = 'AssignedBySeller' and exists(../pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'])">
               <IdReference>
                  <xsl:attribute name="domain">
                     <xsl:value-of select="$domain"/>
                  </xsl:attribute>
                  <xsl:attribute name="identifier">
                     <xsl:value-of select="normalize-space(.)"/>
                  </xsl:attribute>
               </IdReference>
            </xsl:when>
            <xsl:when test="$IdRef = 'DUNSNumber' or $IdRef = 'DUNS+4Number'">
               <IdReference>
                  <xsl:attribute name="domain">
                     <xsl:value-of select="$domain"/>
                  </xsl:attribute>
                  <xsl:attribute name="identifier">
                     <xsl:value-of select="normalize-space(.)"/>
                  </xsl:attribute>
               </IdReference>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
      <xsl:if test="normalize-space($partyInfo/pidx:TaxInformation/pidx:TaxIdentifierNumber) != ''">
         <IdReference>
            <xsl:attribute name="domain">
               <xsl:value-of select="'vatID'"/>
            </xsl:attribute>
            <xsl:attribute name="identifier">
               <xsl:value-of
                  select="normalize-space($partyInfo/pidx:TaxInformation/pidx:TaxIdentifierNumber)"
               />
            </xsl:attribute>
         </IdReference>
      </xsl:if>
      <!-- IG-1238 Legal IdReferences / Extrinsics -->
      <xsl:if test="$partyRole = 'from'">
         <xsl:if
            test="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'GovernmentRegistrationNumber']/pidx:ReferenceNumber) != ''">
            <IdReference>
               <xsl:attribute name="domain">governmentNumber</xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of
                     select="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'GovernmentRegistrationNumber']/pidx:ReferenceNumber)"
                  />
               </xsl:attribute>
            </IdReference>
         </xsl:if>
         <xsl:if
            test="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalForm']/pidx:ReferenceNumber) != ''">
            <Extrinsic>
               <xsl:attribute name="name">LegalStatus</xsl:attribute>
               <xsl:value-of
                  select="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalForm']/pidx:ReferenceNumber)"
               />
            </Extrinsic>
         </xsl:if>
         <xsl:if
            test="normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber) != ''">
            <Extrinsic>
               <xsl:attribute name="name">LegalCapital</xsl:attribute>
               <!--No Money Template used-->
               <Money>
                  <xsl:attribute name="currency">
                     <xsl:value-of
                        select="substring-after(normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber), ' ')"
                     />
                  </xsl:attribute>
                  <xsl:value-of
                     select="substring-before(normalize-space(/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[pidx:Description = 'SupplierLegalCapital']/pidx:ReferenceNumber), ' ')"
                  />
               </Money>
            </Extrinsic>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createInvoiceDetailItem">
      <xsl:param name="item"/>
      <xsl:param name="itemType"/>
      <xsl:param name="HighPartNum"/>
      <xsl:param name="LowPartNum"/>
      <xsl:param name="BuyerPartNum"/>
      <xsl:attribute name="invoiceLineNumber">
         <xsl:value-of select="$item/pidx:LineItemNumber"/>
      </xsl:attribute>
      <xsl:if
         test="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'referencedate']/pidx:ReferenceNumber) != ''">
         <xsl:attribute name="referenceDate">
            <xsl:call-template name="formatDate">
               <xsl:with-param name="DocDate"
                  select="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'referencedate']/pidx:ReferenceNumber)"
               />
            </xsl:call-template>
         </xsl:attribute>
      </xsl:if>
      <xsl:if test="$item/pidx:SpecialInstruction[lower-case(@definitionOfOther) = 'adhocitem']">
         <xsl:attribute name="isAdHoc">
            <xsl:value-of select="'yes'"/>
         </xsl:attribute>
      </xsl:if>
      <xsl:if
         test="$invType = 'lineLevelCreditMemo' and $itemType != 'services' and lower-case($item/pidx:SpecialInstruction[lower-case(@definitionOfOther) = 'creditmemoreason'][@instructionsIndicator = 'Other']) = 'return'">
         <xsl:attribute name="reason">
            <xsl:value-of select="'return'"/>
         </xsl:attribute>
      </xsl:if>
      <xsl:variable name="isLineNegPriceAdjustment">
         <xsl:choose>
            <xsl:when test="$invType = 'lineLevelCreditMemo' and $isLinePriceAdjustment = 'yes'">
               <xsl:text>yes</xsl:text>
            </xsl:when>
            <xsl:when test="$invType = 'lineLevelCreditMemo'">
               <xsl:text>no</xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tempquantity">
         <xsl:choose>
            <xsl:when test="$invType = 'lineLevelCreditMemo' and $isLinePriceAdjustment != 'yes'">
               <xsl:value-of
                  select="concat('-', replace(string($item/pidx:InvoiceQuantity/pidx:Quantity), '-', ''))"
               />
            </xsl:when>
            <xsl:when test="$invType = 'lineLevelCreditMemo'">
               <xsl:value-of
                  select="replace(string($item/pidx:InvoiceQuantity/pidx:Quantity), '-', '')"/>
            </xsl:when>
            <xsl:when test="$invType = 'creditMemo'">
               <xsl:value-of
                  select="concat('-', replace(string($item/pidx:InvoiceQuantity/pidx:Quantity), '-', ''))"
               />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$item/pidx:InvoiceQuantity/pidx:Quantity"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="quantity">
         <xsl:choose>
            <xsl:when test="$tempquantity castable as xs:decimal and xs:decimal($tempquantity) = 0">
               <xsl:value-of select="replace(string($tempquantity), '-', '')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tempquantity"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$itemType = 'services'">
         <InvoiceDetailServiceItemReference>
            <xsl:call-template name="createItemReference">
               <xsl:with-param name="item" select="$item"/>
               <xsl:with-param name="itemType" select="$itemType"/>
               <xsl:with-param name="HighPartNum" select="$HighPartNum"/>
               <xsl:with-param name="LowPartNum" select="$LowPartNum"/>
               <xsl:with-param name="BuyerPartNum" select="$BuyerPartNum"/>
            </xsl:call-template>
         </InvoiceDetailServiceItemReference>
      </xsl:if>
      <xsl:if test="$itemType != 'services'">
         <xsl:call-template name="UOMCodeConversion">
            <xsl:with-param name="UOMCode"
               select="$item/pidx:InvoiceQuantity/pidx:UnitOfMeasureCode"/>
         </xsl:call-template>
         <UnitPrice>
            <xsl:call-template name="createMoney">
               <xsl:with-param name="curr"
                  select="$item/pidx:Pricing/pidx:UnitPrice/pidx:CurrencyCode"/>
               <xsl:with-param name="money"
                  select="$item/pidx:Pricing/pidx:UnitPrice/pidx:MonetaryAmount"/>
               <xsl:with-param name="isLineNegPriceAdjustment" select="$isLineNegPriceAdjustment"/>
            </xsl:call-template>
            <xsl:for-each
               select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Allowance' or @allowanceOrChargeIndicator = 'Charge'][pidx:MethodOfHandlingCode = 'OffInvoice']">
               <Modification>
                  <xsl:choose>
                     <xsl:when test="@allowanceOrChargeIndicator = 'Allowance'">
                        <AdditionalDeduction>
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                 <DeductionAmount>
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="curr"
                                          select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                       <xsl:with-param name="money"
                                          select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                       />
                                    </xsl:call-template>
                                 </DeductionAmount>
                              </xsl:when>
                              <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                 <DeductionPercent>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="pidx:AllowanceOrChargePercent"/>
                                    </xsl:attribute>
                                 </DeductionPercent>
                              </xsl:when>
                           </xsl:choose>
                        </AdditionalDeduction>
                     </xsl:when>
                     <xsl:when test="@allowanceOrChargeIndicator = 'Charge'">
                        <AdditionalCost>
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                 <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                       select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                    <xsl:with-param name="money"
                                       select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                    />
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                 <Percentage>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="pidx:AllowanceOrChargePercent"/>
                                    </xsl:attribute>
                                 </Percentage>
                              </xsl:when>
                           </xsl:choose>
                        </AdditionalCost>
                     </xsl:when>
                  </xsl:choose>
                  <ModificationDetail>
                     <xsl:variable name="ModName" select="pidx:AllowanceOrChargeTypeCode"/>
                     <xsl:attribute name="name">
                        <xsl:value-of
                           select="$cXMLPIDXLookupList/Lookups/AllowanceOrChargeTypeCodes/AllowanceOrChargeTypeCode[PIDXCode = $ModName]/CXMLCode"
                        />
                     </xsl:attribute>
                     <xsl:if
                        test="pidx:MethodOfHandlingCode != '' and pidx:MethodOfHandlingCode != 'Other'">
                        <xsl:variable name="MCode" select="pidx:MethodOfHandlingCode"/>
                        <xsl:attribute name="code">
                           <xsl:value-of
                              select="$cXMLPIDXLookupList/Lookups/MethodOfHandlingCodes/MethodOfHandlingCode[PIDXCode = $MCode]/CXMLCode"
                           />
                        </xsl:attribute>
                     </xsl:if>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of select="pidx:AllowanceOrChargeDescription"/>
                     </Description>
                  </ModificationDetail>
               </Modification>
            </xsl:for-each>
         </UnitPrice>
         <!-- IG-1396 -->
         <xsl:if
            test="$item/pidx:Pricing/pidx:PriceBasis/pidx:Measurement and $item/pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode">
            <PriceBasisQuantity>
               <xsl:attribute name="quantity">
                  <xsl:value-of
                     select="replace(string($item/pidx:Pricing/pidx:PriceBasis/pidx:Measurement), '-', '')"
                  />
               </xsl:attribute>
               <xsl:attribute name="conversionFactor">
                  <xsl:value-of select="'1'"/>
               </xsl:attribute>
               <xsl:call-template name="UOMCodeConversion">
                  <xsl:with-param name="UOMCode"
                     select="$item/pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode"/>
               </xsl:call-template>
               <xsl:if
                  test="normalize-space($item/pidx:Pricing/pidx:PriceBasis/pidx:BasisDescription) != ''">
                  <Description>
                     <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$docLang"/>
                     </xsl:attribute>
                     <xsl:value-of
                        select="normalize-space($item/pidx:Pricing/pidx:PriceBasis/pidx:BasisDescription)"
                     />
                  </Description>
               </xsl:if>
            </PriceBasisQuantity>
         </xsl:if>
      </xsl:if>
      <xsl:if test="$itemType = 'goods'">
         <InvoiceDetailItemReference>
            <xsl:call-template name="createItemReference">
               <xsl:with-param name="item" select="$item"/>
               <xsl:with-param name="itemType" select="$itemType"/>
               <xsl:with-param name="HighPartNum" select="$HighPartNum"/>
               <xsl:with-param name="LowPartNum" select="$LowPartNum"/>
               <xsl:with-param name="BuyerPartNum" select="$BuyerPartNum"/>
            </xsl:call-template>
         </InvoiceDetailItemReference>
      </xsl:if>
      <xsl:if
         test="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrylinenumber']/pidx:ReferenceNumber) != ''">
         <ServiceEntryItemReference>
            <xsl:if
               test="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrynumber']/pidx:ReferenceNumber)">
               <xsl:attribute name="serviceEntryID">
                  <xsl:value-of
                     select="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrynumber']/pidx:ReferenceNumber)"
                  />
               </xsl:attribute>
            </xsl:if>
            <xsl:if
               test="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrydate']/pidx:ReferenceNumber)">
               <xsl:attribute name="serviceEntryDate">
                  <xsl:value-of
                     select="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrydate']/pidx:ReferenceNumber)"
                  />
               </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="serviceLineNumber">
               <xsl:value-of
                  select="normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'serviceentrylinenumber']/pidx:ReferenceNumber)"
               />
            </xsl:attribute>
            <DocumentReference>
               <xsl:attribute name="payloadID"/>
            </DocumentReference>
         </ServiceEntryItemReference>
      </xsl:if>
      <SubtotalAmount>
         <xsl:call-template name="createMoney">
            <xsl:with-param name="curr" select="$item/pidx:LineItemTotal/pidx:CurrencyCode"/>
            <xsl:with-param name="money" select="$item/pidx:LineItemTotal/pidx:MonetaryAmount"/>
         </xsl:call-template>
      </SubtotalAmount>
      <xsl:if test="$itemType = 'services'">
         <Period>
            <xsl:attribute name="startDate">
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate"
                     select="$item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart']"
                  />
               </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="endDate">
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate"
                     select="$item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodEnd']"/>
               </xsl:call-template>
            </xsl:attribute>
         </Period>
         <xsl:if
            test="$item/pidx:Pricing/pidx:UnitPrice and $item/pidx:InvoiceQuantity/pidx:UnitOfMeasureCode">
            <xsl:call-template name="UOMCodeConversion">
               <xsl:with-param name="UOMCode"
                  select="$item/pidx:InvoiceQuantity/pidx:UnitOfMeasureCode"/>
            </xsl:call-template>
            <UnitPrice>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="curr"
                     select="$item/pidx:Pricing/pidx:UnitPrice/pidx:CurrencyCode"/>
                  <xsl:with-param name="money"
                     select="$item/pidx:Pricing/pidx:UnitPrice/pidx:MonetaryAmount"/>
                  <xsl:with-param name="isLineNegPriceAdjustment" select="$isLineNegPriceAdjustment"
                  />
               </xsl:call-template>
            </UnitPrice>
            <!-- IG-1396 -->
            <xsl:if
               test="$item/pidx:Pricing/pidx:PriceBasis/pidx:Measurement and $item/pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode">
               <PriceBasisQuantity>
                  <xsl:attribute name="quantity">
                     <xsl:value-of
                        select="replace(string($item/pidx:Pricing/pidx:PriceBasis/pidx:Measurement), '-', '')"
                     />
                  </xsl:attribute>
                  <xsl:attribute name="conversionFactor">
                     <xsl:value-of select="'1'"/>
                  </xsl:attribute>
                  <xsl:call-template name="UOMCodeConversion">
                     <xsl:with-param name="UOMCode"
                        select="$item/pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode"/>
                  </xsl:call-template>
                  <xsl:if
                     test="normalize-space($item/pidx:Pricing/pidx:PriceBasis/pidx:BasisDescription) != ''">
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="normalize-space($item/pidx:Pricing/pidx:PriceBasis/pidx:BasisDescription)"
                        />
                     </Description>
                  </xsl:if>
               </PriceBasisQuantity>
            </xsl:if>
         </xsl:if>
      </xsl:if>
      <!-- 08152018 CG : WellServiceTax should be mapped as Modification not Tax -->
      <xsl:if test="count($item/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax']) &gt; 0">
         <Tax>
            <xsl:call-template name="createMoney">
               <xsl:with-param name="curr"
                  select="$item/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax'][1]/pidx:TaxAmount/pidx:CurrencyCode"/>
               <xsl:with-param name="money"
                  select="$item/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax'][1]/pidx:TaxAmount/pidx:MonetaryAmount"
               />
            </xsl:call-template>
            <Description>
               <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$docLang"/>
               </xsl:attribute>
               <xsl:choose>
                  <xsl:when test="$item/pidx:Tax[1]/TaxReference">
                     <xsl:value-of select="$item/pidx:Tax[1]/TaxReference"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>Line Item Tax</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </Description>
            <xsl:for-each select="$item/pidx:Tax[pidx:TaxTypeCode != 'WellServiceTax']">
               <TaxDetail>
                  <xsl:attribute name="category">
                     <xsl:variable name="category" select="pidx:TaxTypeCode"/>
                     <xsl:value-of
                        select="$cXMLPIDXLookupList/Lookups/TaxTypes/TaxType[PIDXCode = $category]/CXMLCode"
                     />
                  </xsl:attribute>
                  <xsl:attribute name="percentageRate">
                     <xsl:value-of select="pidx:TaxRate"/>
                  </xsl:attribute>
                  <xsl:if test="normalize-space(pidx:TaxReference) != ''">
                     <xsl:attribute name="taxPointDate">
                        <xsl:call-template name="formatDate">
                           <xsl:with-param name="DocDate"
                              select="normalize-space(pidx:TaxReference)"
                           />
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                     <!-- IG-26422 Zero Rated Tax -->
                     <xsl:when test="number(pidx:TaxRate) = 0 and (pidx:TaxTypeCode = 'ValueAddedTax' or pidx:TaxTypeCode = 'GoodsAndServicesTax')">
                        <xsl:attribute name="exemptDetail">
                           <xsl:text>zeroRated</xsl:text>
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:when test="pidx:TaxExemptCode = 'Exampt' or pidx:TaxExemptCode = 'Exempt'">
                        <xsl:attribute name="exemptDetail">
                           <xsl:text>exempt</xsl:text>
                        </xsl:attribute>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:if test="pidx:TaxBasisAmount">
                     <TaxableAmount>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="curr"
                              select="pidx:TaxBasisAmount/pidx:CurrencyCode"/>
                           <xsl:with-param name="money"
                              select="pidx:TaxBasisAmount/pidx:MonetaryAmount"/>
                        </xsl:call-template>
                     </TaxableAmount>
                  </xsl:if>
                  <TaxAmount>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr" select="pidx:TaxAmount/pidx:CurrencyCode"/>
                        <xsl:with-param name="money" select="pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </xsl:call-template>
                  </TaxAmount>
                  <xsl:if test="pidx:TaxLocation/pidx:LocationName != ''">
                     <TaxLocation>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of
                              select="/pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="pidx:TaxLocation/pidx:LocationName"/>
                     </TaxLocation>
                  </xsl:if>
                  <!-- IG-26422 Zero Rated Tax -->
                  <xsl:if test="number(pidx:TaxRate) = 0 and (pidx:TaxTypeCode = 'ValueAddedTax' or pidx:TaxTypeCode = 'GoodsAndServicesTax')">
                     <Description xml:lang="en">
                        <xsl:text>Zero rated tax</xsl:text>
                     </Description>
                  </xsl:if>
                  <xsl:if test="pidx:TaxLocation/pidx:LocationDescription != ''">
                     <TriangularTransactionLawReference>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of
                              select="/pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="pidx:TaxLocation/pidx:LocationDescription"/>
                     </TriangularTransactionLawReference>
                  </xsl:if>
                  <xsl:if test="pidx:TaxExemptCode = 'NonExempt'">
                     <Extrinsic>
                        <xsl:attribute name="name">
                           <xsl:text>exemptType</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Standard</xsl:text>
                     </Extrinsic>
                  </xsl:if>
               </TaxDetail>
            </xsl:for-each>
         </Tax>
      </xsl:if>      
      <xsl:if
         test="$itemType != 'services' and ($item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty'] or $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty'])">
         <InvoiceDetailLineShipping>
            <xsl:choose>
               <xsl:when test="$itemType != 'services' and ($item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty'] and $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty'])">
                  <InvoiceDetailShipping>
                  <xsl:for-each
                     select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty' or @partnerRoleIndicator = 'ShipFromParty' or
                     @partnerRoleIndicator = 'Carrier']">
                     <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                     <xsl:variable name="getPartyrole"
                        select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                     <Contact>
                        <xsl:attribute name="role">
                           <xsl:value-of select="$getPartyrole"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressID">
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                 <xsl:value-of
                                    select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                 />
                              </xsl:when>
                              <xsl:when
                                 test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                 <xsl:value-of
                                    select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                 />
                              </xsl:when>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:variable name="addressIDDomain">
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                 <xsl:value-of select="'assignedByBuyer'"/>
                              </xsl:when>
                              <xsl:when
                                 test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                 <xsl:value-of select="'assignedBySeller'"/>
                              </xsl:when>
                              <xsl:otherwise/>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$addressIDDomain != ''">
                           <xsl:attribute name="addressIDDomain">
                              <xsl:value-of select="$addressIDDomain"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="CreateContact">
                           <xsl:with-param name="partyInfo" select="."/>
                        </xsl:call-template>
                     </Contact>
                  </xsl:for-each>
                  </InvoiceDetailShipping>
               </xsl:when>
               <xsl:when test="$itemType != 'services' and $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']">
                  <InvoiceDetailShipping>
                     <xsl:for-each
                        select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty' or @partnerRoleIndicator = 'Carrier']">
                        <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                        <xsl:variable name="getPartyrole"
                           select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="$getPartyrole"/>
                           </xsl:attribute>
                           <xsl:attribute name="addressID">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                    />
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:variable name="addressIDDomain">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                    <xsl:value-of select="'assignedByBuyer'"/>
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                    <xsl:value-of select="'assignedBySeller'"/>
                                 </xsl:when>
                                 <xsl:otherwise/>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:if test="$addressIDDomain != ''">
                              <xsl:attribute name="addressIDDomain">
                                 <xsl:value-of select="$addressIDDomain"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:call-template name="CreateContact">
                              <xsl:with-param name="partyInfo" select="."/>
                           </xsl:call-template>
                        </Contact>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'shipFrom'"/>
                           </xsl:attribute>
                           <Name xml:lang="EN"></Name>
                        </Contact>                        
                     </xsl:for-each>
                  </InvoiceDetailShipping>
               </xsl:when>
               <xsl:when test="$itemType != 'services' and $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
                  <InvoiceDetailShipping>
                     <xsl:for-each
                        select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty' or @partnerRoleIndicator = 'Carrier']">
                        <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                        <xsl:variable name="getPartyrole"
                           select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="$getPartyrole"/>
                           </xsl:attribute>
                           <xsl:attribute name="addressID">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                    <xsl:value-of
                                       select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                    />
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:variable name="addressIDDomain">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                    <xsl:value-of select="'assignedByBuyer'"/>
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                    <xsl:value-of select="'assignedBySeller'"/>
                                 </xsl:when>
                                 <xsl:otherwise/>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:if test="$addressIDDomain != ''">
                              <xsl:attribute name="addressIDDomain">
                                 <xsl:value-of select="$addressIDDomain"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:call-template name="CreateContact">
                              <xsl:with-param name="partyInfo" select="."/>
                           </xsl:call-template>
                        </Contact>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'shipTo'"/>
                           </xsl:attribute>
                           <Name xml:lang="EN"></Name>
                        </Contact>                        
                     </xsl:for-each>
                  </InvoiceDetailShipping>
               </xsl:when>
            </xsl:choose>
           
            <xsl:choose>
               <xsl:when test="$item/pidx:ShippingAmount/pidx:MonetaryAmount != ''">
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="curr"
                        select="$item/pidx:ShippingAmount/pidx:CurrencyCode"/>
                     <xsl:with-param name="money"
                        select="$item/pidx:ShippingAmount/pidx:MonetaryAmount"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when
                  test="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="curr"
                        select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                     <xsl:with-param name="money"
                        select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                     />
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="curr" select="$item/pidx:LineItemTotal/pidx:CurrencyCode"
                     />
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </InvoiceDetailLineShipping>
      </xsl:if>
      <xsl:if
         test="$itemType != 'services' and normalize-space($item/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber) != ''">
         <ShipNoticeIDInfo>
            <xsl:if
               test="normalize-space($item/pidx:ServiceDateTime[@dateTypeIndicator = 'PromisedForShipment']) != ''">
               <xsl:attribute name="shipNoticeDate">
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="normalize-space($item/pidx:ServiceDateTime[@dateTypeIndicator = 'PromisedForShipment'])"
                     />
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="shipNoticeID">
               <xsl:value-of
                  select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber"
               />
            </xsl:attribute>
            <xsl:if
               test="normalize-space($item/pidx:ServiceDateTime[@dateTypeIndicator = 'ShippedDate']) != ''">
               <IdReference>
                  <xsl:attribute name="domain">
                     <xsl:text>deliveryNoteDate</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="identifier">
                     <xsl:value-of
                        select="normalize-space($item/pidx:ServiceDateTime[@dateTypeIndicator = 'ShippedDate'])"
                     />
                  </xsl:attribute>
               </IdReference>
            </xsl:if>
         </ShipNoticeIDInfo>
      </xsl:if>
      <!--InvoiceItemModifications-->
      <xsl:if
         test="
            (($item/pidx:AllowanceOrCharge/@allowanceOrChargeIndicator = 'Allowance' or
            $item/pidx:AllowanceOrCharge/@allowanceOrChargeIndicator = 'Charge') and
            count($item/pidx:AllowanceOrCharge[pidx:MethodOfHandlingCode != 'OffInvoice']) &gt; 0) or $item/pidx:Tax[pidx:TaxTypeCode = 'WellServiceTax']">
         <InvoiceItemModifications>
            <xsl:for-each
               select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Allowance' or @allowanceOrChargeIndicator = 'Charge'][pidx:MethodOfHandlingCode != 'OffInvoice']">
               <Modification>
                  <xsl:choose>
                     <xsl:when test="@allowanceOrChargeIndicator = 'Allowance'">
                        <AdditionalDeduction>
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                 <DeductionAmount>
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="curr"
                                          select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                       <xsl:with-param name="money"
                                          select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                       />
                                    </xsl:call-template>
                                 </DeductionAmount>
                              </xsl:when>
                              <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                 <DeductionPercent>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="pidx:AllowanceOrChargePercent"/>
                                    </xsl:attribute>
                                 </DeductionPercent>
                              </xsl:when>
                           </xsl:choose>
                        </AdditionalDeduction>
                     </xsl:when>
                     <xsl:when test="@allowanceOrChargeIndicator = 'Charge'">
                        <AdditionalCost>
                           <xsl:choose>
                              <xsl:when
                                 test="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                                 <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                       select="pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                                    <xsl:with-param name="money"
                                       select="pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                                    />
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:when test="pidx:AllowanceOrChargePercent != ''">
                                 <Percentage>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="pidx:AllowanceOrChargePercent"/>
                                    </xsl:attribute>
                                 </Percentage>
                              </xsl:when>
                           </xsl:choose>
                        </AdditionalCost>
                     </xsl:when>
                  </xsl:choose>
                  <ModificationDetail>
                     <xsl:variable name="ModName" select="pidx:AllowanceOrChargeTypeCode"/>
                     <xsl:attribute name="name">
                        <xsl:value-of
                           select="$cXMLPIDXLookupList/Lookups/AllowanceOrChargeTypeCodes/AllowanceOrChargeTypeCode[PIDXCode = $ModName]/CXMLCode"
                        />
                     </xsl:attribute>
                     <xsl:if
                        test="pidx:MethodOfHandlingCode != '' and pidx:MethodOfHandlingCode != 'Other'">
                        <xsl:variable name="MCode" select="pidx:MethodOfHandlingCode"/>
                        <xsl:attribute name="code">
                           <xsl:value-of
                              select="$cXMLPIDXLookupList/Lookups/MethodOfHandlingCodes/MethodOfHandlingCode[PIDXCode = $MCode]/CXMLCode"
                           />
                        </xsl:attribute>
                     </xsl:if>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of select="pidx:AllowanceOrChargeDescription"/>
                     </Description>
                  </ModificationDetail>
               </Modification>
            </xsl:for-each>
            <xsl:for-each select="$item/pidx:Tax[pidx:TaxTypeCode = 'WellServiceTax']">
               <Modification>
                  <AdditionalCost>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr" select="pidx:TaxAmount/pidx:CurrencyCode"/>
                        <xsl:with-param name="money" select="pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </xsl:call-template>
                  </AdditionalCost>
                  <ModificationDetail>
                     <xsl:attribute name="name">
                        <xsl:value-of select="'Charge'"/>
                     </xsl:attribute>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="$docLang != ''">
                                 <xsl:value-of select="$docLang"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'en'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="pidx:TaxTypeCode"/>
                     </Description>
                  </ModificationDetail>
               </Modification>
            </xsl:for-each>
         </InvoiceItemModifications>
      </xsl:if>
      <xsl:if
         test="
            $item/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber'] or
            $item/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter'] or
            $item/pidx:ReferenceInformation[@referenceInformationIndicator = 'OperatorGeneralLedgerCode']
            or $item/pidx:ReferenceInformation[@referenceInformationIndicator = 'ProjectNumber'] or
            $item/pidx:ReferenceInformation[@referenceInformationIndicator = 'JobNumber'] or
            $item/pidx:ReferenceInformation[pidx:Description = 'WorkOrderID'] or $item/pidx:ReferenceInformation[pidx:Description = 'WBSID']">
         <Distribution>
            <Accounting name="DistributionCharge">
               <xsl:if
                  test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:text>AFENumber</xsl:text>
                     </Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber']/pidx:Description"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <xsl:if
                  test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>CostCenter</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter']/pidx:Description"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <xsl:if
                  test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'OperatorGeneralLedgerCode']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'OperatorGeneralLedgerCode']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>GeneralLedger</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'OperatorGeneralLedgerCode']/pidx:Description"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <!-- IG-1313 -->
               <xsl:if
                  test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'ProjectNumber']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'ProjectNumber']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>Project</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'ProjectNumber']/pidx:Description"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <xsl:if
                  test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'JobNumber']/pidx:ReferenceNumber != ''">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'JobNumber']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>InternalOrder</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'JobNumber']/pidx:Description"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <xsl:if test="$item/pidx:ReferenceInformation[pidx:Description = 'WorkOrderID']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[pidx:Description = 'WorkOrderID']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>WorkOrderNumber</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="
                              $item/pidx:ReferenceInformation[pidx:Description =
                              'WorkOrderDescription']/pidx:ReferenceNumber"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <xsl:if test="$item/pidx:ReferenceInformation[pidx:Description = 'WBSID']">
                  <AccountingSegment>
                     <xsl:attribute name="id">
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[pidx:Description = 'WBSID']/pidx:ReferenceNumber"
                        />
                     </xsl:attribute>
                     <Name>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>WBSElement</Name>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$docLang"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="$item/pidx:ReferenceInformation[pidx:Description = 'WBSDescription']/pidx:ReferenceNumber"
                        />
                     </Description>
                  </AccountingSegment>
               </xsl:if>
               <AccountingSegment id="100.00">
                  <Name>
                     <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$docLang"/>
                     </xsl:attribute>Percentage</Name>
                  <Description>
                     <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$docLang"/>
                     </xsl:attribute>
                  </Description>
               </AccountingSegment>
            </Accounting>
            <Charge>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="curr" select="$item/pidx:LineItemTotal/pidx:CurrencyCode"/>
                  <xsl:with-param name="money" select="$item/pidx:LineItemTotal/pidx:MonetaryAmount"
                  />
               </xsl:call-template>

            </Charge>
         </Distribution>
      </xsl:if>
      <Comments>
         <xsl:attribute name="xml:lang">
            <xsl:value-of select="$docLang"/>
         </xsl:attribute>
         <xsl:value-of select="$item/pidx:Comment"/>
      </Comments>
      <xsl:for-each
         select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']">
         <xsl:if
            test="normalize-space(pidx:Description) != '' and not(contains('|WorkOrderID|WorkOrderDescription|WBSID|WBSDescription|TaxPointDate|', pidx:Description))">
            <Extrinsic>
               <xsl:attribute name="name">
                  <xsl:value-of select="normalize-space(pidx:Description)"/>
               </xsl:attribute>
               <xsl:value-of select="normalize-space(pidx:ReferenceNumber)"/>
            </Extrinsic>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="createHeaderInvoiceItem">
      <xsl:param name="item"/>
      <xsl:element name="InvoiceDetailOrderSummary">
         <xsl:attribute name="invoiceLineNumber">
            <xsl:value-of select="$item/pidx:LineItemNumber"/>
         </xsl:attribute>
         <SubtotalAmount>
            <xsl:call-template name="createMoney">
               <xsl:with-param name="curr" select="$item/pidx:LineItemTotal/pidx:CurrencyCode"/>
               <xsl:with-param name="money" select="$item/pidx:LineItemTotal/pidx:MonetaryAmount"/>
            </xsl:call-template>
         </SubtotalAmount>
         <!-- Period -->
         <xsl:if
            test="$item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart'] and $item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodEnd']">
            <Period>
               <xsl:attribute name="startDate">
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="$item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart']"
                     />
                  </xsl:call-template>
               </xsl:attribute>
               <xsl:attribute name="endDate">
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="$item/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodEnd']"
                     />
                  </xsl:call-template>
               </xsl:attribute>
            </Period>
         </xsl:if>
         <!-- Tax -->
         <xsl:if test="$item/pidx:Tax">
            <Tax>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="curr"
                     select="$item/pidx:Tax[1]/pidx:TaxAmount/pidx:CurrencyCode"/>
                  <xsl:with-param name="money"
                     select="$item/pidx:Tax[1]/pidx:TaxAmount/pidx:MonetaryAmount"/>
               </xsl:call-template>
               <Description>
                  <xsl:attribute name="xml:lang">
                     <xsl:value-of select="$docLang"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="$item/pidx:Tax[1]/TaxReference">
                        <xsl:value-of select="$item/pidx:Tax[1]/TaxReference"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>Order Summary Tax</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </Description>
               <xsl:for-each select="$item/pidx:Tax">
                  <TaxDetail>
                     <xsl:attribute name="category">
                        <xsl:variable name="category" select="pidx:TaxTypeCode"/>
                        <xsl:value-of
                           select="$cXMLPIDXLookupList/Lookups/TaxTypes/TaxType[PIDXCode = $category]/CXMLCode"
                        />
                     </xsl:attribute>
                     <xsl:attribute name="percentageRate">
                        <xsl:value-of select="pidx:TaxRate"/>
                     </xsl:attribute>
                     <xsl:if test="normalize-space(pidx:TaxReference) != ''">
                        <xsl:attribute name="taxPointDate">
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="normalize-space(pidx:TaxReference)"
                              />
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:if test="pidx:TaxExemptCode = 'Exampt' or pidx:TaxExemptCode = 'Exempt'">
                        <xsl:attribute name="exemptDetail">
                           <xsl:text>exempt</xsl:text>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:if test="pidx:TaxBasisAmount">
                        <TaxableAmount>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="curr"
                                 select="pidx:TaxBasisAmount/pidx:CurrencyCode"/>
                              <xsl:with-param name="money"
                                 select="pidx:TaxBasisAmount/pidx:MonetaryAmount"/>
                           </xsl:call-template>
                        </TaxableAmount>
                     </xsl:if>
                     <TaxAmount>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="curr" select="pidx:TaxAmount/pidx:CurrencyCode"/>
                           <xsl:with-param name="money" select="pidx:TaxAmount/pidx:MonetaryAmount"
                           />
                        </xsl:call-template>
                     </TaxAmount>
                     <xsl:if test="pidx:TaxLocation/pidx:LocationName != ''">
                        <TaxLocation>
                           <xsl:attribute name="xml:lang">
                              <xsl:value-of
                                 select="/pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
                           </xsl:attribute>
                           <xsl:value-of select="pidx:TaxLocation/pidx:LocationName"/>
                        </TaxLocation>
                     </xsl:if>
                     <xsl:if test="pidx:TaxLocation/pidx:LocationDescription != ''">
                        <TriangularTransactionLawReference>
                           <xsl:attribute name="xml:lang">
                              <xsl:value-of
                                 select="/pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
                           </xsl:attribute>
                           <xsl:value-of select="pidx:TaxLocation/pidx:LocationDescription"/>
                        </TriangularTransactionLawReference>
                     </xsl:if>
                     <xsl:if test="pidx:TaxExemptCode = 'NonExempt'">
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:text>exemptType</xsl:text>
                           </xsl:attribute>
                           <xsl:text>Standard</xsl:text>
                        </Extrinsic>
                     </xsl:if>
                  </TaxDetail>
               </xsl:for-each>
            </Tax>
         </xsl:if>
         <!-- InvoiceDetailLineShipping -->
         <xsl:if
            test="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty'] or $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
            <InvoiceDetailLineShipping>
               <xsl:choose>
                  <xsl:when test="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty'] and $item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
                     <InvoiceDetailShipping>
                        <xsl:for-each
                           select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty' or @partnerRoleIndicator = 'ShipFromParty' or
                           @partnerRoleIndicator = 'Carrier']">
                           <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                           <xsl:variable name="getPartyrole"
                              select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressID">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                       />
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                       />
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:variable name="addressIDDomain">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                       <xsl:value-of select="'assignedByBuyer'"/>
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                       <xsl:value-of select="'assignedBySeller'"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:if test="$addressIDDomain != ''">
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="$addressIDDomain"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                              </xsl:call-template>
                           </Contact>
                        </xsl:for-each>
                     </InvoiceDetailShipping>
                  </xsl:when>
                  <xsl:when test="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty']">
                     <InvoiceDetailShipping>
                        <xsl:for-each
                           select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipToParty' or @partnerRoleIndicator = 'Carrier']">
                           <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                           <xsl:variable name="getPartyrole"
                              select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressID">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                       />
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                       />
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:variable name="addressIDDomain">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                       <xsl:value-of select="'assignedByBuyer'"/>
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                       <xsl:value-of select="'assignedBySeller'"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:if test="$addressIDDomain != ''">
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="$addressIDDomain"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                              </xsl:call-template>
                           </Contact>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'shipFrom'"/>
                              </xsl:attribute>
                              <Name xml:lang="EN"></Name>
                           </Contact>                        
                        </xsl:for-each>
                     </InvoiceDetailShipping>
                  </xsl:when>
                  <xsl:when test="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty']">
                     <InvoiceDetailShipping>
                        <xsl:for-each
                           select="$item/pidx:PartnerInformation[@partnerRoleIndicator = 'ShipFromParty' or @partnerRoleIndicator = 'Carrier']">
                           <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                           <xsl:variable name="getPartyrole"
                              select="$cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode"/>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="$getPartyrole"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressID">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']"
                                       />
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']">
                                       <xsl:value-of
                                          select="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller']"
                                       />
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:variable name="addressIDDomain">
                                 <xsl:choose>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                       <xsl:value-of select="'assignedByBuyer'"/>
                                    </xsl:when>
                                    <xsl:when
                                       test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller'] != ''">
                                       <xsl:value-of select="'assignedBySeller'"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:if test="$addressIDDomain != ''">
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="$addressIDDomain"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                              </xsl:call-template>
                           </Contact>
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'shipTo'"/>
                              </xsl:attribute>
                              <Name xml:lang="EN"></Name>
                           </Contact>                        
                        </xsl:for-each>
                     </InvoiceDetailShipping>
                  </xsl:when>
               </xsl:choose>
               
               <xsl:choose>
                  <xsl:when test="$item/pidx:ShippingAmount/pidx:MonetaryAmount != ''">
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                           select="$item/pidx:ShippingAmount/pidx:CurrencyCode"/>
                        <xsl:with-param name="money"
                           select="$item/pidx:ShippingAmount/pidx:MonetaryAmount"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:when
                     test="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount != ''">
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                           select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:CurrencyCode"/>
                        <xsl:with-param name="money"
                           select="$item/pidx:AllowanceOrCharge[@allowanceOrChargeIndicator = 'Charge'][lower-case(normalize-space(pidx:AllowanceOrChargeTypeCode)) = 'freight']/pidx:AllowanceOrChargeTotalAmount/pidx:MonetaryAmount"
                        />
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr" select="$item/pidx:LineItemTotal/pidx:CurrencyCode"
                        />
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </InvoiceDetailLineShipping>
         </xsl:if>
         
         <!-- Comments -->
         <Comments>
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="$docLang"/>
            </xsl:attribute>
            <xsl:value-of select="$item/pidx:Comment"/>
         </Comments>
         <!--Extriniscs-->
         <xsl:for-each
            select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']">
            <xsl:if
               test="normalize-space(pidx:Description) != '' and not(contains('|WorkOrderID|WorkOrderDescription|WBSID|WBSDescription|TaxPointDate|', pidx:Description))">
               <Extrinsic>
                  <xsl:attribute name="name">
                     <xsl:value-of select="normalize-space(pidx:Description)"/>
                  </xsl:attribute>
                  <xsl:value-of select="normalize-space(pidx:ReferenceNumber)"/>
               </Extrinsic>
            </xsl:if>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createItemReference">
      <xsl:param name="itemType"/>
      <xsl:param name="item"/>
      <xsl:param name="HighPartNum"/>
      <xsl:param name="LowPartNum"/>
      <xsl:param name="BuyerPartNum"/>
      <xsl:attribute name="lineNumber">
         <xsl:value-of select="$item/pidx:PurchaseOrderLineItemNumber"/>
      </xsl:attribute>
      <xsl:if
         test="$itemType = 'services' and $item/pidx:CommodityCode[@agencyIndicator = 'UNSPSC'] != ''">
         <Classification>
            <xsl:attribute name="domain">
               <xsl:text>UNSPSC</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$item/pidx:CommodityCode[@agencyIndicator = 'UNSPSC']"/>
         </Classification>
      </xsl:if>
      <ItemID>
         <SupplierPartID>
            <xsl:choose>
               <xsl:when test="$HighPartNum != ''">
                  <xsl:value-of select="$HighPartNum"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of
                     select="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedBySeller']"
                  />
               </xsl:otherwise>
            </xsl:choose>
         </SupplierPartID>
         <xsl:choose>
            <xsl:when test="$LowPartNum">
               <SupplierPartAuxiliaryID>
                  <xsl:value-of select="$LowPartNum"/>
               </SupplierPartAuxiliaryID>
            </xsl:when>
            <xsl:when
               test="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'CatalogueNumber'] != ''">
               <SupplierPartAuxiliaryID>
                  <xsl:value-of
                     select="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'CatalogueNumber']"
                  />
               </SupplierPartAuxiliaryID>
            </xsl:when>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="$BuyerPartNum">
               <xsl:value-of select="$BuyerPartNum"/>
            </xsl:when>
            <xsl:when
               test="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedByBuyer']">
               <BuyerPartID>
                  <xsl:value-of
                     select="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedByBuyer']"
                  />
               </BuyerPartID>
            </xsl:when>
         </xsl:choose>
         <xsl:if test="$item/pidx:FieldTicketInformation != ''">
            <IdReference>
               <xsl:attribute name="domain">
                  <xsl:text>FieldTicketNumber</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of select="$item/pidx:FieldTicketInformation/pidx:FieldTicketNumber"/>
               </xsl:attribute>
            </IdReference>
         </xsl:if>
         <xsl:if
            test="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber != ''">
            <IdReference>
               <xsl:attribute name="domain">
                  <xsl:text>DeliveryTicketNumber</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of
                     select="$item/pidx:ReferenceInformation[@referenceInformationIndicator = 'DeliveryTicketNumber']/pidx:ReferenceNumber"
                  />
               </xsl:attribute>
            </IdReference>
         </xsl:if>
         <xsl:if
            test="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'UPCNumber']">
            <IdReference>
               <xsl:attribute name="domain">
                  <xsl:text>UPCID</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of
                     select="$item/pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'UPCNumber']"
                  />
               </xsl:attribute>
            </IdReference>
         </xsl:if>
      </ItemID>
      <xsl:choose>
         <xsl:when test="$item/pidx:LineItemInformation/pidx:LineItemDescription != ''">
            <Description>
               <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$docLang"/>
               </xsl:attribute>
               <xsl:value-of select="$item/pidx:LineItemInformation/pidx:LineItemDescription"/>
            </Description>
         </xsl:when>
         <xsl:when test="$item/pidx:LineItemInformation/pidx:LineItemName != ''">
            <Description>
               <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$docLang"/>
               </xsl:attribute>
               <xsl:value-of select="$item/pidx:LineItemInformation/pidx:LineItemName"/>
            </Description>
         </xsl:when>
      </xsl:choose>
      <xsl:if
         test="$itemType = 'goods' and $item/pidx:CommodityCode[@agencyIndicator = 'UNSPSC'] != ''">
         <Classification>
            <xsl:attribute name="domain">
               <xsl:text>UNSPSC</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$item/pidx:CommodityCode[@agencyIndicator = 'UNSPSC']"/>
         </Classification>
      </xsl:if>
      <xsl:if
         test="$itemType = 'goods' and $item/pidx:LineItemInformation/pidx:ManufacturerIdentifier != ''">
         <ManufacturerPartID>
            <xsl:value-of select="$item/pidx:LineItemInformation/pidx:ManufacturerIdentifier"/>
         </ManufacturerPartID>
         <ManufacturerName/>
      </xsl:if>
      <xsl:if test="$itemType = 'goods' and $item/pidx:CountryOfOrigin/pidx:CountryCode != ''">
         <Country>
            <xsl:attribute name="isoCountryCode">
               <xsl:value-of select="$item/pidx:CountryOfOrigin/pidx:CountryCode"/>
            </xsl:attribute>
         </Country>
      </xsl:if>
   </xsl:template>
   <xsl:template name="formatDate">
      <xsl:param name="DocDate"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="Time1" select="substring($DocDate, 11)"/>
            <xsl:variable name="ExtractLastChara" select="substring($Time1, string-length($Time1), 1)" />
            <xsl:variable name="offSet">               
                  <xsl:choose>
                     <xsl:when test="string-length($ExtractLastChara) &gt; 0">
                        <xsl:if test="string(number($ExtractLastChara)) = 'NaN'">
                           <xsl:value-of select="'true'"/>
                        </xsl:if>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="'false'"/>
                     </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Time">
               <xsl:choose>
                  <!-- if 2021-06-02T00:00:00Z , dont append time Stamp. As 'Z' is an Offset value -->
                  <xsl:when test="$offSet = 'true'">
                     <xsl:value-of select="''"/>
                  </xsl:when>
                  <xsl:when test="string-length($Time1) &gt; 0">
                     <xsl:variable name="timezone"
                        select="concat(substring-after($Time1, '+'), substring-after($Time1, '-'))"/>
                     <xsl:choose>
                        <xsl:when test="string-length($timezone) &gt; 0">
                           <xsl:value-of select="''"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$anSenderDefaultTimeZone"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat('T00:00:00', $anSenderDefaultTimeZone)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($DocDate, $Time)"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createMoney">
      <xsl:param name="curr"/>
      <xsl:param name="money"/>
      <xsl:param name="isLineNegPriceAdjustment"/>
      <xsl:variable name="mainMoney">
         <xsl:choose>
            <xsl:when test="string($money) != ''">
               <xsl:value-of select="$money"/>
            </xsl:when>
            <xsl:otherwise>0.00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="moneyVal">
         <xsl:choose>
            <xsl:when test="$isLineNegPriceAdjustment = 'yes'">
               <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
            </xsl:when>
            <xsl:when test="$isLineNegPriceAdjustment = 'no'">
               <xsl:value-of select="$mainMoney"/>
            </xsl:when>
            <xsl:when test="$isCreditMemo = 'yes'">
               <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$mainMoney"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="currency">
         <xsl:choose>
            <xsl:when test="$curr != ''">
               <xsl:value-of select="$curr"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$HCur"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="Money">
         <xsl:attribute name="currency">
            <xsl:value-of select="$currency"/>
         </xsl:attribute>
         <xsl:choose>
            <xsl:when test="$moneyVal castable as xs:decimal and xs:decimal($moneyVal) = 0">
               <xsl:value-of select="replace(string($moneyVal), '-', '')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$moneyVal"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template name="UOMCodeConversion">
      <xsl:param name="UOMCode"/>
      <xsl:choose>
         <xsl:when
            test="lower-case($anANSILookupFlag) = 'true' and $UOMCode = 'DH'">
            <xsl:element name="UnitOfMeasure">
               <xsl:value-of
                  select="'SMI'"
               />
            </xsl:element>
         </xsl:when>
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
