<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:typens="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0"> <!--<IG-37162 : XSLT Improvements >-->
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/> <!--<IG-37162 : XSLT Improvements>-->
<!--		    <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
	    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anSenderID1"/>
	<xsl:param name="anSourceDocumentType"/>
	<xsl:variable name="v_Header" select="typens:PaymentExportRequest/typens:Payment_PaymentHeaderExport_Item/typens:item"/>
	<xsl:variable name="v_GlAcc" select="typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item/typens:Accountings/typens:SplitAccountings/typens:item"/>
	<xsl:variable name="v_GlAccMain" select="typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item"/>
	<xsl:variable name="v_ItemData" select="typens:PaymentExportRequest/typens:Payment_PaymentLineItemDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item"/>
	<xsl:variable name="v_AccData" select="typens:PaymentExportRequest/typens:Payment_EnhancedPaymentAccountDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item/typens:Accountings/typens:SplitAccountings/typens:item"/>
	<xsl:variable name="v_Tax" select="typens:PaymentExportRequest/typens:Payment_PaymentTaxExport_Item/typens:item/typens:InvoiceReconciliation/typens:TaxDistributionVector/typens:item"/>
	<xsl:variable name="v_AdvPay" select="typens:PaymentExportRequest/typens:Payment_AdvancePaymentDetailExport_Item/typens:item/typens:AdvancePayments/typens:item"/>
	<xsl:variable name="v_AddrData" select="typens:PaymentExportRequest/typens:Payment_PaymentHeaderExport_Item/typens:item/typens:InvoiceReconciliation/typens:OneTimeVendorInvoiceDetail"/>
	<xsl:variable name="v_payTaxExport" select="typens:PaymentExportRequest/typens:Payment_PaymentTaxExport_Item/typens:item/typens:InvoiceReconciliation/typens:TaxDistributionVector"/>	
	<xsl:variable name="v_matchedReceipt" select="typens:PaymentExportRequest/typens:Payment_PaymentMatchedReceiptsDet_Item/typens:item/typens:InvoiceReconciliation/typens:MatchedReceipts/typens:item"/>
	<!--   <xsl:variable name="v_pd" select="'ParameterCrossreference.xml'"/>-->
		<xsl:variable name="v_pd">
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
			<xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
		</xsl:call-template>
	</xsl:variable>
	<!--Begin of IG-16335 : PO based HeaderLevel CreditMemo -->
	<!--<xsl:variable name="v_NoPoNumber" select="(typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item/typens:ERPPONumber) = ''"/>
		A creditMemo needs to have account information. ACCOUNTINGDATA is populated for a PO based CM (since it has a defined account info), where as for a NON-PO invoice we populate GLACCOUNT.
		For a HeaderLevel CM, we should simulate it as a NonPO invoice and populate GLAccount.
		Above code has been modified because, for a Headerlevel CM, ERP PO number exists, but not POLineNumber. 
		Modifying that code snippet will still be valid for all regular LineLevel CM, because a POLineNumber will be present.-->
	<xsl:variable name="v_NoPoNumber"
		select="(typens:PaymentExportRequest/typens:Payment_PaymentLineItemDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item[1]/typens:POLineNumber) = ''"/>
	<!--End of IG-16335-->
	<!-- Non-PO Invoice FI Indicator -->		
 	<xsl:variable name="v_fiindicator">		
 		<xsl:if test="$v_NoPoNumber = boolean('true')">					
 			<xsl:call-template name="FillDocType">		
 				<xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>		
 				<xsl:with-param name="p_ordCategory" select="'FIINV_IND'"/>		
 				<xsl:with-param name="p_pd" select="$v_pd"/>		
 			</xsl:call-template>		
 		</xsl:if>		
 	</xsl:variable>
	<xsl:variable name="v_DisableTaxOnShipHandling">
<!--Check is included to also check if ExpectedTax is not present for those lines. set the flag is satisfies-->
<!--This is to handle charges at header level-->
<!--IG-19285-->		
		<xsl:value-of select=
			"(((typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item
			[typens:LineType/typens:Category = '4' or typens:LineType/typens:Category = '8' or typens:LineType/typens:Category = '16']
			/typens:Parent/typens:NumberInCollection) &gt; 0 ) 
			and 
			(not(exists((typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item
			[typens:LineType/typens:Category = '4' or typens:LineType/typens:Category = '8' or typens:LineType/typens:Category = '16'] 
			/typens:ExpectedTax/typens:TaxCode/typens:UniqueName)))))
			or 
			(not(exists((typens:PaymentExportRequest/typens:Payment_PaymentGLAccDet_Item/typens:item/typens:InvoiceReconciliation/typens:LineItems/typens:item
			[typens:LineType/typens:Category = '4' or typens:LineType/typens:Category = '8' or typens:LineType/typens:Category = '16'] 
			/typens:ExpectedTax))))"/>		
	</xsl:variable>
<!--IG-19285-->		
	<!--Logic for Subsequent Credit/Debit Indicator	-->
	<xsl:variable name="v_DebCreInd">
		<xsl:if
			test="$v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:IsPriceAdjustmentInvoice = 'true'">
			<xsl:value-of select="'X'"/>
		</xsl:if>		
	</xsl:variable>
	<!--Logic for Document value PD Reference type-->
	<!--Newer order category types included for Subs.Credit and Debit-->
	<xsl:variable name="v_OrdCat">	
		<xsl:call-template name="ValidatePriceChangeType"/>
	</xsl:variable>	
	<!--Withholding Tax Amount at Header Level-->
	<xsl:variable name="v_WithholdingData">
		<xsl:for-each select="$v_GlAcc">
			<xsl:choose>
				<xsl:when test="upper-case(../../../typens:IsHeaderLevelLine) = 'TRUE' and ../../../typens:LineType/typens:Category = '64'">
				  <item>
					<LineNo>
						<xsl:value-of select="../../../typens:NumberInCollection"/>
					</LineNo>
					<TaxCode>
						<xsl:value-of select="../../../typens:ExpectedTax/typens:TaxCode/typens:UniqueName"/>
					</TaxCode>
					<uniqueid>
						<xsl:value-of select="upper-case(../../../typens:LineType/typens:UniqueName)"/>
					</uniqueid>
				  </item>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="v_WithholdingTaxAmmount">
		<xsl:for-each select="$v_ItemData">
				<xsl:choose>
				<xsl:when test="typens:NumberInCollection = $v_WithholdingData/item/LineNo">
					<item>
						<xsl:attribute name="LineNo">
							<xsl:value-of select="typens:NumberInCollection"/>
						</xsl:attribute>
					<Amount>
						<!--Consume ERPPrecision Value-->
						<xsl:variable name="v_FinalERPAmt">
							<xsl:call-template name="ConsumeERPAmount">
								<xsl:with-param name="p_ERPAmt" select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
								<xsl:with-param name="p_Amt" select = "typens:Amount/typens:Amount"/>
							</xsl:call-template>
						</xsl:variable>
					<xsl:choose>
						<xsl:when test="starts-with(string($v_FinalERPAmt), '-')">
							<xsl:value-of select="$v_FinalERPAmt * -1.00"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$v_FinalERPAmt"/>
						</xsl:otherwise>
					</xsl:choose>
					</Amount>
					</item>
				</xsl:when>
			</xsl:choose>
			
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="v_TotalWithholdingTaxAmmount" select="sum($v_WithholdingTaxAmmount/item/Amount)"/>
	<!--Discount calucation for PO & Non-PO based Lines-->
	<xsl:variable name="DiscountDetails">
		<xsl:choose>
			<!--PO based Discount calculation, Check for PO Number-->
			<xsl:when test="$v_ItemData/typens:ERPPONumber != ''">
				<xsl:for-each select="$v_ItemData">
					<xsl:variable name="v_FinalERPDisc">
						<xsl:call-template name="ConsumeERPAmount">
							<xsl:with-param name="p_ERPAmt" select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
							<xsl:with-param name="p_Amt" select = "typens:Amount/typens:Amount"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<!--Header Level, check for PO Line Number is Null-->
						<xsl:when test="typens:LineType/typens:Category = '32' and typens:POLineNumber = ''">
							<!--Get the Discount Ammount, convert it to Positive-->
							<xsl:variable name="v_ItemDis">
								<xsl:choose>
									<xsl:when test="starts-with(string($v_FinalERPDisc), '-')">
										<xsl:value-of select="$v_FinalERPDisc * -1.00"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$v_FinalERPDisc"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!--Call Template to calucalte Discounted amounts of Line items-->
							<xsl:call-template name="DiscountedAmounts">
								<xsl:with-param name="p_tableName" select="'ItemData'"/>
								<xsl:with-param name="p_ItemDis" select="$v_ItemDis"/>
							</xsl:call-template>
						</xsl:when>
						<!--  Line Level, check for PO Line Number is Not Null-->
						<xsl:when test="typens:LineType/typens:Category = '32' and typens:POLineNumber != ''">
							<Item>
								<!--Get the Discount Ammount, convert it to Positive-->
								<xsl:variable name="v_ItemDis">
									<xsl:choose>
										<xsl:when test="starts-with(string($v_FinalERPDisc), '-')">
											<xsl:value-of select="$v_FinalERPDisc * -1.00"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$v_FinalERPDisc"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!--Get the PO Line Number-->
								<xsl:variable name="v_po_line" select="typens:POLineNumber"/>
								<xsl:choose>
									<!--Get the coressponding Line to Apply Discount based on PO Line Number-->
									<xsl:when test=" $v_ItemData/typens:LineType/typens:Category = '1' and $v_ItemData/typens:POLineNumber = $v_po_line">
										<!--Get the coressponding NumberInCollection of main Line based on PO Line Number-->
										<xsl:attribute name="NumberInCollection">
											<xsl:value-of select="$v_ItemData[typens:POLineNumber = $v_po_line and typens:LineType/typens:Category = '1']/typens:NumberInCollection"/>
										</xsl:attribute>
										<!--Get the coressponding Amount of main Line based on PO Line Number-->
										<xsl:variable name="v_ItemAmount">
											<xsl:value-of select="($v_ItemData[typens:POLineNumber = $v_po_line and typens:LineType/typens:Category = '1']/typens:Amount/typens:Amount)"/>
										</xsl:variable>
										<!--Get the Main Lime Quantity for Account Data , convert it to Positive -->
										<xsl:variable name="v_Quantity" select="($v_ItemData[typens:POLineNumber = $v_po_line and typens:LineType/typens:Category = '1']/typens:Quantity)"/>
										<xsl:attribute name="Quantity">
											<xsl:choose>
												<xsl:when test="starts-with(string($v_Quantity), '-')">
													<xsl:value-of select="$v_Quantity * -1.000"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$v_Quantity"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<Amount>
											<!--Remove negative value and apply Discount at main Line-->
											<xsl:choose>
												<xsl:when test="starts-with(string($v_ItemAmount), '-')">
													<xsl:value-of select="($v_ItemAmount * -1.00 ) - $v_ItemDis"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$v_ItemAmount - $v_ItemDis"/>
												</xsl:otherwise>
											</xsl:choose>
										</Amount>
									</xsl:when>
								</xsl:choose>
							</Item>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<!-- Non-PO based Discount calculation, Check there is No PO Number-->
			<xsl:when test="$v_NoPoNumber = boolean('true')">
				<xsl:for-each select="$v_GlAccMain">
					<xsl:choose>
						<!--Header Level - Non-PO, check for IsHeaderLevelLine = 'true'-->
						<xsl:when test="typens:LineType/typens:Category = '32' and typens:IsHeaderLevelLine = 'true'">
							<!--Get the Discount Ammount, convert it to Positive-->
							<xsl:variable name="v_GlItemDis">
								<xsl:choose>
									<xsl:when
										test="exists(typens:Accountings/typens:SplitAccountings/typens:item/typens:AdjustedCostInERPPrecision/typens:Amount)">
										<xsl:choose>
											<xsl:when
												test="starts-with(string(typens:Accountings/typens:SplitAccountings/typens:item/typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
												<xsl:value-of
													select="typens:Accountings/typens:SplitAccountings/typens:item/typens:AdjustedCostInERPPrecision/typens:Amount * -1.00"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="typens:Accountings/typens:SplitAccountings/typens:item/typens:AdjustedCostInERPPrecision/typens:Amount"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when
												test="starts-with(string(typens:Accountings/typens:SplitAccountings/typens:item/typens:Amount/typens:Amount), '-')">
												<xsl:value-of
													select="typens:Accountings/typens:SplitAccountings/typens:item/typens:Amount/typens:Amount * -1.00"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="typens:Accountings/typens:SplitAccountings/typens:item/typens:Amount/typens:Amount"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!--Call Template to calucalte Discounted amounts of GL Line-->
							<xsl:call-template name="DiscountedAmounts">
								<xsl:with-param name="p_tableName" select="'GLData'"/>
								<xsl:with-param name="p_ItemDis" select="$v_GlItemDis"/>
							</xsl:call-template>
						</xsl:when>
						<!--  Line Level - Non-PO, check for IsHeaderLevelLine = 'false'-->
						<xsl:when test="typens:LineType/typens:Category = '32' and typens:IsHeaderLevelLine = 'false'">
							<!--Get the Parent / Main Line Number-->
							<xsl:variable name="v_ParentNumberInCollection" select="typens:Parent/typens:NumberInCollection"/>
							<!--Check is there any other discount for same Parent Line-->
							<xsl:variable name="v_DiscSum">
								<xsl:for-each select="$v_GlAcc">
									<xsl:if test="../../../typens:Parent/typens:NumberInCollection = $v_ParentNumberInCollection and ../../../typens:LineType/typens:Category = '32' and ../../../typens:IsHeaderLevelLine = 'false' ">
										<value>
											<!--convert Amount to Positive-->
											<xsl:choose>
												<xsl:when
													test="exists(typens:AdjustedCostInERPPrecision/typens:Amount)">
													<xsl:choose>
														<xsl:when
															test="starts-with(string(typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
															<xsl:value-of
																select="format-number(typens:AdjustedCostInERPPrecision/typens:Amount * -1.00, '0.00')"
															/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of
																select="format-number(typens:AdjustedCostInERPPrecision/typens:Amount, '0.00')"
															/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when
															test="starts-with(string(typens:Amount/typens:Amount), '-')">
															<xsl:value-of
																select="format-number(typens:Amount/typens:Amount * -1.00, '0.00')"
															/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of
																select="format-number(typens:Amount/typens:Amount, '0.00')"
															/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</value>
									</xsl:if>
								</xsl:for-each>
							</xsl:variable>
							<!--Get the Discount Ammount -->
							<xsl:variable name="v_GlLineDis" select="sum($v_DiscSum/value)"/>
							<!--Get the coressponding Line with 'NumberInCollection = $v_ParentNumberInCollection' to Apply Discount-->
							<xsl:variable name="v_sum">
								<xsl:for-each select="$v_GlAcc">
									<xsl:choose>
										<!-- Including LineType Category 4,8,16 to consider for Discount -->
										<xsl:when test="(../../../typens:LineType/typens:Category = '1' or ../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16' or string-length(normalize-space(../../../typens:LineType/typens:Category)) = 0) and ../../../typens:NumberInCollection = $v_ParentNumberInCollection"><!--<IG-37162 : XSLT Improvements >-->
											<value>
												<xsl:attribute name="NumberInCollection" select="concat(../../../typens:NumberInCollection,typens:NumberInCollection)"/>
												<amount>
													<!--convert Amount to Positive-->
													<xsl:choose>
														<xsl:when
															test="exists(typens:AdjustedCostInERPPrecision/typens:Amount)">
															<xsl:choose>
																<xsl:when
																	test="starts-with(string(typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
																	<xsl:value-of
																		select="format-number(typens:AdjustedCostInERPPrecision/typens:Amount * -1.00, '0.00')"
																	/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of
																		select="format-number(typens:AdjustedCostInERPPrecision/typens:Amount, '0.00')"
																	/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when
																	test="starts-with(string(typens:Amount/typens:Amount), '-')">
																	<xsl:value-of
																		select="format-number(typens:Amount/typens:Amount * -1.00, '0.00')"
																	/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of
																		select="format-number(typens:Amount/typens:Amount, '0.00')"
																	/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</amount>
											</value>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:variable>
							<!--Call Template to Calculate Discounted amount-->
							<xsl:call-template name="CalculateDiscount">
								<xsl:with-param name="p_AmtSum" select="$v_sum"/>
								<xsl:with-param name="p_ItemDis" select="$v_GlLineDis"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<!--Getting the Service Sheet no-->
	<xsl:variable name="v_SES_No">
		<xsl:for-each select="$v_ItemData">
			<Item>
				<xsl:attribute name="NumberInCollection">
					<xsl:value-of select="typens:NumberInCollection"/>
				</xsl:attribute>
				<SHEET_NO>
					<xsl:value-of select="typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID"/>
				</SHEET_NO>
			</Item>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name = "v_taxsource">
		<xsl:value-of select="typens:PaymentExportRequest/typens:Payment_PaymentHeaderExport_Item/typens:item/typens:InvoiceReconciliation/typens:TaxSource"/>
	</xsl:variable>
	<xsl:template match="/">
		<n0:ARBCIG_BAPI_INVOICE_CREATE>
<!--			<IG-37162 : XSLT Improvements, Rearranging tags >-->
			<!-- One time vendor development CI-11005 -->
			<!-- Address Data -->
			<xsl:if test="exists($v_AddrData)">
				<ADDRESSDATA>
					<ACC_1_TIME>
						<xsl:value-of select="'X'"/>		
					</ACC_1_TIME>
					<NAME>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierName,1,35)"/>
					</NAME>
					<NAME_2>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierName,36,35)"/>
					</NAME_2>
					<NAME_3>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierName,71,35)"/>
					</NAME_3>
					<NAME_4>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierName,106,35)"/>
					</NAME_4>
					<POSTL_CODE>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierRemitToAddress/typens:PostalAddress/typens:PostalCode,1,10)"/>
					</POSTL_CODE>
					<CITY>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierRemitToAddress/typens:PostalAddress/typens:City,1,35)"/>
					</CITY>
					<COUNTRY>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierRemitToAddress/typens:PostalAddress/typens:Country/typens:UniqueName,1,3)"/>
					</COUNTRY>
					<STREET>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierRemitToAddress/typens:PostalAddress/typens:Lines,1,35)"/>
					</STREET>
					<BANK_ACCT>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierPaymentLocation/typens:BankAccountID,1,18)"/>
					</BANK_ACCT>
					<BANK_NO>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierPaymentLocation/typens:BankID,1,15)"/>
					</BANK_NO>
					<BANK_CTRY>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierPaymentLocation/typens:BankAddress/typens:PostalAddress/typens:Country/typens:UniqueName,1,3)"/>
					</BANK_CTRY>
					<REGION>
						<xsl:value-of select="substring($v_AddrData/typens:SupplierRemitToAddress/typens:PostalAddress/typens:State,1,3)"/>
					</REGION>
				</ADDRESSDATA>
			</xsl:if>	
			<!-- End of Address Data -->	
			<!--       Attachment code     -->
			<xsl:if test="/typens:PaymentExportRequest/typens:Payment_PaymentAttachmentsExport_Item/typens:item/typens:Invoice/typens:ExportedAttachments">			
				<ATTACHMENT>
					<xsl:for-each select="/typens:PaymentExportRequest/typens:Payment_PaymentAttachmentsExport_Item/typens:item/typens:Invoice/typens:ExportedAttachments/typens:item">
						<item>
							<FILE_NAME>
								<xsl:value-of select="typens:Attachment/typens:Filename"/>
							</FILE_NAME>
							<CONTENT_ID>
								<xsl:value-of select="typens:MaskedFileName"/>
							</CONTENT_ID>
							<CONTENT_TYPE>
								<xsl:value-of select="typens:Attachment/typens:Attachment/typens:ContentType"/>
							</CONTENT_TYPE>
						</item>
					</xsl:for-each>
				</ATTACHMENT>
			</xsl:if>
			<!-- FI Invoice Indicator Mapping -->
			<xsl:if test="($v_fiindicator = 'TRUE')">
				<FIINVIND>
					<xsl:value-of select="'X'"/>
				</FIINVIND>	
			</xsl:if>			
			<HEADERDATA>
				<UNIQUEID>
					<xsl:value-of select="$v_Header/typens:UniqueName"/>
				</UNIQUEID>
				<INVOICE_IND>
					<xsl:value-of select="$v_Header/typens:InvoiceReconciliation/typens:SAPInvoiceInd"/>
				</INVOICE_IND>
				<xsl:choose>
					<!-- Fetching FI Document type  only if FI Indicator is set to 'TRUE', else standard Document type will be fecthed. -->
					<xsl:when test="$v_fiindicator = 'TRUE' and 
						($v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:IsPriceAdjustmentInvoice = 'false' or 
						string-length(normalize-space($v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:IsPriceAdjustmentInvoice))= 0)"> <!--<IG-37162 : XSLT Improvements >-->	
						<DOC_TYPE>
							<xsl:call-template name="FillDocType">
								<xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
								<xsl:with-param name="p_ordCategory" select="'FIINV'"/>
								<xsl:with-param name="p_pd" select="$v_pd"/>
							</xsl:call-template>
						</DOC_TYPE>
					</xsl:when>
					<xsl:otherwise>
						<DOC_TYPE>
							<xsl:call-template name="FillDocType">
								<xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
								<!--Introduce new order categories for sub. credit and debit , made order category dynamic-->
								<xsl:with-param name="p_ordCategory" select="$v_OrdCat"/>
								<xsl:with-param name="p_pd" select="$v_pd"/>
							</xsl:call-template>
						</DOC_TYPE>
					</xsl:otherwise>
				</xsl:choose>
				<DOC_DATE>
					<xsl:variable name="v_doc_date" select="$v_Header/typens:InvoiceReconciliation/typens:InvoiceDate"/>
					<xsl:if test="string-length(normalize-space($v_doc_date))> 0"> <!--<IG-37162 : XSLT Improvements >-->
						<xsl:choose>
							<xsl:when test="contains($v_doc_date,'-')">
								<xsl:value-of select="substring($v_doc_date, 1, 10)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="concat(substring($v_doc_date, 1, 4), '-', substring($v_doc_date, 5, 2), '-', substring($v_doc_date, 7, 2))"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</DOC_DATE>
				<REF_DOC_NO>
					<xsl:value-of select="upper-case($v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:InvoiceNumber)"/>
				</REF_DOC_NO>
				<COMP_CODE>
					<xsl:value-of select="$v_Header/typens:InvoiceReconciliation/typens:CompanyCode/typens:UniqueName"/>
				</COMP_CODE>
				<DIFF_INV>
					<xsl:value-of select="$v_Header/typens:SupplierLocation/typens:UniqueName"/>
				</DIFF_INV>
				<CURRENCY>
					<xsl:value-of select="$v_Header/typens:Amount/typens:Currency/typens:UniqueName"/>
				</CURRENCY>
				<GROSS_AMOUNT>
					<!-- Begin of IG-18187 : Change GROSS_AMOUNT for non-PO based on ERPPrecision -->
					<xsl:choose>
						<xsl:when test="$v_Header/typens:InvoiceReconciliation/typens:AdjustedTotalCostInERPPrecision/typens:Amount != ''">
							<xsl:choose>
								<xsl:when test="starts-with(string($v_Header/typens:InvoiceReconciliation/typens:AdjustedTotalCostInERPPrecision/typens:Amount), '-')">
									<xsl:value-of select="format-number(($v_Header/typens:InvoiceReconciliation/typens:AdjustedTotalCostInERPPrecision/typens:Amount * -1.00) + $v_TotalWithholdingTaxAmmount, '0.00')"/>					
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number($v_Header/typens:InvoiceReconciliation/typens:AdjustedTotalCostInERPPrecision/typens:Amount + $v_TotalWithholdingTaxAmmount, '0.00')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- End of IG-18187 : Change GROSS_AMOUNT for non-PO based on ERPPrecision -->		
							<!--Remove negative value-->
							<xsl:choose>
								<xsl:when test="starts-with(string($v_Header/typens:PaymentAmounts/typens:GrossAmount/typens:Amount), '-')">
									<xsl:value-of select="format-number(($v_Header/typens:PaymentAmounts/typens:GrossAmount/typens:Amount * -1.00) + $v_TotalWithholdingTaxAmmount, '0.00')"/>					
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number($v_Header/typens:PaymentAmounts/typens:GrossAmount/typens:Amount + $v_TotalWithholdingTaxAmmount, '0.00')"/>
								</xsl:otherwise>
							</xsl:choose>
							<!-- Begin of IG-18187 : Change GROSS_AMOUNT for non-PO based on ERPPrecision -->		
						</xsl:otherwise>
					</xsl:choose>	
					<!-- End of IG-18187 : Change GROSS_AMOUNT for non-PO based on ERPPrecision -->
				</GROSS_AMOUNT>
				<PMNTTRMS>
					<xsl:value-of select="$v_Header/typens:PaymentTerms/typens:UniqueName"/>
				</PMNTTRMS>
				<BLINE_DATE>
					<xsl:variable name="v_bline_date" select="$v_Header/typens:InvoiceReconciliation/typens:BaselineDateString"/>
					<xsl:value-of select="concat(substring($v_bline_date, 1, 4), '-', substring($v_bline_date, 5, 2), '-', substring($v_bline_date, 7, 2))"/>
				</BLINE_DATE>
				<HEADER_TXT>
					<xsl:value-of select="'ARIBA_P2P'"/>
				</HEADER_TXT>
				<!--<IG-37162 : XSLT Improvements, Rearranging tags >-->
				<!--Unplaned costs GL Account data for Shipping & Spl chanrges without Tax - Pass Total ammount at Header Level -->
				<xsl:variable name="v_Sum">
					<xsl:for-each select="$v_GlAcc">
						<xsl:choose>
							<xsl:when test="$v_DisableTaxOnShipHandling = boolean('true') and (../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16')">
								<value>
									<xsl:choose>
										<xsl:when
											test="exists(typens:AdjustedCostInERPPrecision/typens:Amount)">
											<xsl:choose>
												<xsl:when
													test="starts-with(string(typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
													<xsl:value-of
														select="(typens:AdjustedCostInERPPrecision/typens:Amount * -1)"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="typens:AdjustedCostInERPPrecision/typens:Amount"
													/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when
													test="starts-with(string(typens:Amount/typens:Amount), '-')">
													<xsl:value-of
														select="(typens:Amount/typens:Amount * -1)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="typens:Amount/typens:Amount"
													/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</value>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<DEL_COSTS>
					<xsl:value-of select="format-number(sum($v_Sum/value), '0.00')"/>
				</DEL_COSTS>				
				<PYMT_METH>
					<xsl:value-of select="$v_Header/typens:PaymentMethodType/typens:UniqueName"/>
				</PYMT_METH>
				<ITEM_TEXT>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($v_Header/typens:InvoiceReconciliation/typens:UniqueName)) > 50"> <!--<IG-37162 : XSLT Improvements >-->
							<xsl:value-of select="substring($v_Header/typens:InvoiceReconciliation/typens:UniqueName, 1, 50)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($v_Header/typens:InvoiceReconciliation/typens:UniqueName, 1, 50)"/> <!--IG-39684 : Payment Request ITEM_TEXT not Truncating to 50 Char-->
						</xsl:otherwise>
					</xsl:choose>
				</ITEM_TEXT>
				<TAX_SOURCE>
					<xsl:value-of select="$v_taxsource"/>
				</TAX_SOURCE>
			</HEADERDATA>
			<!-- Variant and Partition Mapping-->
			<PARTITION>
				<xsl:value-of select="typens:PaymentExportRequest/@partition"/>
			</PARTITION>
			<VARIANT>
				<xsl:value-of select="typens:PaymentExportRequest/@variant"/>
			</VARIANT>		
			<!-- Accounting Data-->
			<ACCOUNTINGDATA>
				<xsl:for-each select="$v_AccData">
					<xsl:if test="../../../typens:LineType/typens:Category = '1' and ../../../typens:ERPPONumber != ''">
						<item>
							<CATEGORY>
								<xsl:value-of select="../../../typens:LineType/typens:Category"/>
							</CATEGORY>
							<ARIBA_WBS_ELEM>
								<xsl:value-of select="typens:WBSElement/typens:UniqueName"/>
							</ARIBA_WBS_ELEM>
							<INVOICE_DOC_ITEM>
								<xsl:value-of select="../../../typens:NumberInCollection"/>
							</INVOICE_DOC_ITEM>
							<SERIAL_NO>
								<xsl:value-of select="typens:SAPSerialNumber"/>
							</SERIAL_NO>
							<TAX_CODE>
								<xsl:value-of select="../../../typens:ExpectedTax/typens:TaxCode/typens:UniqueName"/>
							</TAX_CODE>
							<xsl:variable name="v_AccQuantity">
								<!--Remove negative value-->
								<xsl:choose>
									<xsl:when test="starts-with(string(typens:Quantity), '-')">
										<xsl:value-of select="format-number(typens:Quantity * -1.00, '0.000')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(typens:Quantity, '0.000')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="v_NumberInCollection" select="../../../typens:NumberInCollection"/>
							<!--Consume ERP Precision amount-->
							<xsl:variable name="v_ERPAccAmt">
								<xsl:call-template name="ConsumeERPAmount">
									<xsl:with-param name="p_ERPAmt" select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
									<xsl:with-param name="p_Amt" select="typens:Amount/typens:Amount"/>
								</xsl:call-template>
							</xsl:variable>							
							<ITEM_AMOUNT>
								<!--Get the Item Quantity into local variable-->
								<xsl:variable name="v_ItemQuantity" select="$DiscountDetails/Item[@NumberInCollection = $v_NumberInCollection]/@Quantity"/>
								<xsl:choose>
									<!--Amount Based PO : POLineReceivingType = '3'-->
									<!-- Begin of IG-17962 : Commenting logic as causing issues in ERP, to populate ITEM_AMOUNT based on POLineReceivingType = '3'-->
									<!-- <xsl:when test="../../../typens:POLineReceivingType = '3'">1.00</xsl:when> -->										
									<!-- End of IG-17962 : Commenting logic as causing issues in ERP, to populate ITEM_AMOUNT based on POLineReceivingType = '3'-->									
									<!--When coressponding line have Dicount the apply formula ((DiscountedItemAmount / ItemQuantity)* AccountingQuantity)-->
									<xsl:when test="$DiscountDetails/Item[@NumberInCollection = $v_NumberInCollection]">
										<!-- Discount-->
										<xsl:value-of select="format-number(($DiscountDetails/Item[@NumberInCollection = $v_NumberInCollection]/Amount div $v_ItemQuantity) * $v_AccQuantity, '0.00')"/>							
									</xsl:when>
									<xsl:otherwise>
										<!-- if there is no Discount for a line then Directly map -->
										<xsl:choose>
											<xsl:when test="starts-with(string($v_ERPAccAmt), '-')">
												<xsl:value-of select="format-number($v_ERPAccAmt * -1.00, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($v_ERPAccAmt, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</ITEM_AMOUNT>
							<!-- Check is this Service Line -->
							<xsl:variable name="v_SES" select="($v_SES_No/Item[@NumberInCollection = $v_NumberInCollection]/SHEET_NO) != ''"/>
							<xsl:choose>
								<!--Check Distribution - If the line item is a split by amount we need to pass the po_unit, PO_PR_UOM and Quantity as blank-->
								<!-- Check is this Service Line, If yes Don't pass Quantity PO uint as blank, Else pass all details -->
								<xsl:when test="( ../../../typens:OrderLineItem/typens:SAPDistributionFlag = '3' or ( $v_SES = boolean('true') 
									and ( not(exists($v_ItemData[typens:NumberInCollection = $v_NumberInCollection]/typens:OrderLineItem/typens:ERSAllowed)) 
									or $v_ItemData[typens:NumberInCollection = $v_NumberInCollection]/typens:OrderLineItem/typens:ERSAllowed = '' 
									or $v_ItemData[typens:NumberInCollection = $v_NumberInCollection]/typens:OrderLineItem/typens:ERSAllowed = 'false' ))
									or ../../../typens:OrderLineItem/typens:ServiceDetails/typens:NonSESBasedInvoice = 'true' ) ">
									<QUANTITY>
										<xsl:value-of select="format-number(0, '0.000')"/>
									</QUANTITY>
									<PO_UNIT/>
									<PO_PR_UOM/>
								</xsl:when>
								<xsl:when test="../../../typens:OrderLineItem/typens:SAPDistributionFlag != '3' 
									or ($v_SES = boolean('true') and $v_ItemData[typens:NumberInCollection = $v_NumberInCollection]/typens:OrderLineItem/typens:ERSAllowed = 'true')">
									<QUANTITY>
										<xsl:value-of select="$v_AccQuantity"/>
									</QUANTITY>
									<PO_UNIT>
										<xsl:value-of select="../../../typens:Description/typens:UnitOfMeasure/typens:UniqueName"/>
									</PO_UNIT>
									<PO_PR_UOM>
										<xsl:value-of select="../../../typens:Description/typens:PriceBasisQuantityUOM/typens:UniqueName"/>
									</PO_PR_UOM>
								</xsl:when>
								<xsl:otherwise>
									<QUANTITY>
										<xsl:choose>
											<!--Amount Based PO : POLineReceivingType = '3'-->
											<xsl:when test="../../../typens:POLineReceivingType = '3'">
												<!-- start of IG-18636 : change negative to amount value to positive  -->
												<xsl:variable name="v_ERPAccAmt1">
													<!--Remove negative value-->
													<xsl:choose>
														<xsl:when test="starts-with(string($v_ERPAccAmt), '-')">
															<xsl:value-of select="format-number($v_ERPAccAmt * -1.00, '0.000')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="format-number($v_ERPAccAmt, '0.000')"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:value-of select="format-number($v_ERPAccAmt1 * $v_AccQuantity, '0.000')"/>
												<!-- end of IG-18636 : change negative to amount value to positive  -->
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$v_AccQuantity"/>
											</xsl:otherwise>
										</xsl:choose>
									</QUANTITY>
									<PO_UNIT>
										<xsl:value-of select="../../../typens:Description/typens:UnitOfMeasure/typens:UniqueName"/>
									</PO_UNIT>
									<PO_PR_UOM>
										<xsl:value-of select="../../../typens:Description/typens:PriceBasisQuantityUOM/typens:UniqueName"/>
									</PO_PR_UOM>
								</xsl:otherwise>
							</xsl:choose>
							<GL_ACCOUNT>
								<xsl:value-of select="typens:GeneralLedger/typens:UniqueName"/>
							</GL_ACCOUNT>
							<COSTCENTER>
								<xsl:value-of select="typens:CostCenter/typens:UniqueName"/>
							</COSTCENTER>
							<ASSET_NO>
								<xsl:value-of select="typens:Asset/typens:UniqueName"/>
							</ASSET_NO>
							<SUB_NUMBER>
								<xsl:value-of select="typens:Asset/typens:SubNumber"/>
							</SUB_NUMBER>
							<ORDERID>
								<xsl:value-of select="typens:InternalOrder/typens:UniqueName"/>
							</ORDERID>
							<FUNDS_CTR>
								<xsl:value-of select="typens:custom/typens:CustomFundsCenter/typens:UniqueName"/>
							</FUNDS_CTR>
							<FUND>
								<xsl:value-of select="typens:custom/typens:CustomFund/typens:UniqueName"/>
							</FUND>
							<!--IG-28021: Mapping Network and Activity for Account assignment -->
							<xsl:if test="string-length(normalize-space(typens:Network/typens:UniqueName)) > 0">
							<NETWORK>
								<xsl:value-of select="typens:Network/typens:UniqueName"/>
							</NETWORK>
							</xsl:if>
							<xsl:if test="string-length(normalize-space(typens:ActivityNumber/typens:UniqueName)) > 0">
							<ACTIVITY>
								<xsl:value-of select="typens:ActivityNumber/typens:UniqueName"/>
							</ACTIVITY>
							</xsl:if>
							<!--IG-28021: Mapping Network and Activity for Account assignment -->
							<GRANT_NBR>
								<xsl:value-of select="typens:custom/typens:CustomGrant/typens:UniqueName"/>
							</GRANT_NBR>
							<CMMT_ITEM_LONG>
								<xsl:value-of select="typens:custom/typens:CustomCommitmentItem/typens:UniqueName"/>
							</CMMT_ITEM_LONG>
							<FUNC_AREA_LONG>
								<xsl:value-of select="typens:custom/typens:CustomFunctionalArea/typens:UniqueName"/>
							</FUNC_AREA_LONG>
							<BUDGET_PERIOD>
								<xsl:value-of select="typens:custom/typens:CustomBudgetPeriod/typens:UniqueName"/>
							</BUDGET_PERIOD>
							<!--IG-18110-->
							<xsl:if test="(not(exists(../../../typens:OrderLineItem/typens:SAPDistributionFlag)) or ../../../typens:OrderLineItem/typens:SAPDistributionFlag != '3')
								and $v_SES = boolean('true')
								and (not(exists(../../../typens:OrderLineItem/typens:ServiceDetails/typens:NonSESBasedInvoice)) or ../../../typens:OrderLineItem/typens:ServiceDetails/typens:NonSESBasedInvoice = 'false')">
								<SRV_QUANTITY>
									<xsl:value-of select="$v_AccQuantity"/>
								</SRV_QUANTITY>
								<SRV_PO_UNIT>
									<xsl:value-of select="../../../typens:Description/typens:UnitOfMeasure/typens:UniqueName"/>
								</SRV_PO_UNIT>
								<SRV_PO_PR_UOM>
									<xsl:value-of select="../../../typens:Description/typens:PriceBasisQuantityUOM/typens:UniqueName"/>
								</SRV_PO_PR_UOM>
							</xsl:if>
							<!--IG-18110-->
							<!--IG-20194-->
							<ARIBA_ITEM_NO>
								<xsl:value-of select="typens:NumberInCollection"/>
							</ARIBA_ITEM_NO>
							<!--IG-20194-->
						</item>
					</xsl:if>
				</xsl:for-each>
			</ACCOUNTINGDATA>
			<!--<IG-37162 : XSLT Improvements, Rearranging tags >-->
			<!--Advanced Payment Data-->
			<xsl:if test="$v_AdvPay">
				<ADVANCE_PAYMENT>
					<xsl:for-each select="$v_AdvPay">
						<item>
							<INVOICE_DOC_ITEM>
								<xsl:value-of select="$v_ItemData[1]/typens:NumberInCollection"/>
							</INVOICE_DOC_ITEM>
							<FISC_YEAR>
								<xsl:value-of select="typens:AdvancePayment/typens:FiscalYear"/>
							</FISC_YEAR>
							<VDP_ID>
								<xsl:value-of select="typens:AdvancePaymentERPRequestID"/>
							</VDP_ID>
							<VDP_ITEM>
								<xsl:value-of select="typens:AdvancePaymentLineItem/typens:AdvancePaymentLineItemRemittance/typens:ERPRequestLineNumber"/>
							</VDP_ITEM>
							<DPR_ID>
								<xsl:value-of select="typens:AdvancePayment/typens:UniqueName"/>
							</DPR_ID>
							<PO_NUMBER>
								<xsl:value-of select="typens:PurchaseOrder/typens:OrderID"/>
							</PO_NUMBER>
							<PO_ITEM>
								<xsl:value-of select="typens:AdvancePaymentLineItem/typens:OrderLineItem/typens:SAPPOLineNumber"/>
							</PO_ITEM>
							<AMOUNT>
								<!--Remove negative value-->
								<xsl:choose>
									<xsl:when test="starts-with(string(typens:ConsumedAmount/typens:Amount), '-')">
										<xsl:value-of select="format-number((typens:ConsumedAmount/typens:Amount * -1.00), '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(typens:ConsumedAmount/typens:Amount, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</AMOUNT>
							<CURRENCY>
								<xsl:value-of select="typens:ConsumedAmount/typens:Currency/typens:UniqueName"/>
							</CURRENCY>
						</item>
					</xsl:for-each>
				</ADVANCE_PAYMENT>
			</xsl:if>			
			<!--GL Account Data-->
			<GLACCOUNTDATA>
				<xsl:for-each select="$v_GlAcc">
					<xsl:choose>
						<!-- Filling GLACCOUNTDATA for FI NOn-PO Invoice, if FI Indicator is set to 'true', otherwise standard logic will get executed-->
						<xsl:when test="($v_fiindicator = 'TRUE')">
							<!--Filling shipping or handling line items when taxes on shipping and handling is enabled(FI Non-PO based invoices) -->
							<xsl:if test="(../../../typens:LineType/typens:Category = '1' or ../../../typens:LineType/typens:Category = '0' or ../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16' or string-length(normalize-space(../../../typens:LineType/typens:Category)) = 0)"> <!--<IG-37162 : XSLT Improvements >-->
								<!--Call Template for GL Account Lines-->
								<xsl:call-template name="GlAccountDataTempletIn"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
					<xsl:choose>
						<!--Filling Non-PO Based main line items -->
						<xsl:when test="$v_NoPoNumber = boolean('true') and (../../../typens:LineType/typens:Category = '1' or string-length(normalize-space(../../../typens:LineType/typens:Category)) = 0 )"> <!--<IG-37162 : XSLT Improvements >-->
							<!--Call Template for GL Account Lines-->
							<xsl:call-template name="GlAccountDataTempletIn"/>
						</xsl:when>
						<!--Filling shipping or handling line items when taxes on shipping and handling is enabled(True for both PO based and Non-PO based invoices) -->
						<xsl:when test="$v_DisableTaxOnShipHandling != boolean('true') and (../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16')">
							<!--Call Template for GL Account Lines-->
							<xsl:call-template name="GlAccountDataTempletIn"/>
						</xsl:when>
					</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</GLACCOUNTDATA>
			<!--Item Data-->
			<ITEMDATA>
				<xsl:for-each select="$v_ItemData">
					<xsl:if test="typens:LineType/typens:Category = '1' and typens:ERPPONumber != ''">
						<item>
							<CATEGORY>
								<xsl:value-of select="typens:LineType/typens:Category"/>
							</CATEGORY>
							<INVOICE_DOC_ITEM>
								<xsl:value-of select="typens:NumberInCollection"/>
							</INVOICE_DOC_ITEM>
							<PO_NUMBER>
								<xsl:value-of select="typens:ERPPONumber"/>
							</PO_NUMBER>
							<PO_ITEM>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID)) > 0"> <!--<IG-37162 : XSLT Improvements>-->
										<!--  for unplanned service PO releted Invoice Parent line tag will not be present in cXML 
											  and thus item number need to be chosen directly from OrderLineItem->SAPPOLineNumber tag only	-->										
										<xsl:choose>	
											<!--for Planned Service PO invoice -->											
											<xsl:when test="exists(typens:OrderLineItem/typens:Parent/typens:SAPPOLineNumber)">										
												<xsl:value-of select="typens:OrderLineItem/typens:Parent/typens:SAPPOLineNumber"/>
											</xsl:when>	
											<!--for Unplanned Service PO invoice-->											
											<xsl:otherwise>	
												<xsl:value-of select="typens:OrderLineItem/typens:SAPPOLineNumber"/>
											</xsl:otherwise>	
										</xsl:choose>											
									</xsl:when>
									<xsl:when test="exists(typens:OrderLineItem/typens:SAPPOLineNumber) 
										and string-length(normalize-space(typens:OrderLineItem/typens:SAPPOLineNumber)) > 0"> <!--<IG-37162 : XSLT Improvements>-->
										<xsl:value-of select="typens:OrderLineItem/typens:SAPPOLineNumber"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="typens:POLineNumber"/>
									</xsl:otherwise>
								</xsl:choose>
							</PO_ITEM>
							<xsl:variable name="v_NumberInCollection" select="typens:NumberInCollection"/>
							<!--<CI-1014 - GR-based Invoice Verification in P2P (SAP Ariba Buying and Invoicing)-->
							<xsl:if test="((typens:OrderLineItem/typens:ERSAllowed = 'true' and not(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID))
								or (typens:GRBasedInvoice = 'true' and not(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID)))">
							<!--<CI-1014 - GR-based Invoice Verification in P2P (SAP Ariba Buying and Invoicing)--> 
								<REF_DOC>
									<xsl:value-of select="$v_matchedReceipt[typens:LineNumber = $v_NumberInCollection]/typens:MatchedReceiptItems/typens:item/typens:ReceiptItem/typens:Receipt/typens:ERPReceiptNumber"/>
								</REF_DOC>
								<REF_DOC_IT>
									<xsl:value-of select="$v_matchedReceipt[typens:LineNumber = $v_NumberInCollection]/typens:MatchedReceiptItems/typens:item/typens:ReceiptItem/typens:NumberInCollection"/>
								</REF_DOC_IT>	
							</xsl:if>
							<!--Subsequent Debit/Credit Indicator-->
							<DE_CRE_IND>
									<xsl:value-of select = "$v_DebCreInd"/>									
							</DE_CRE_IND>
							<TAX_CODE>
								<xsl:value-of select="typens:ExpectedTax/typens:TaxCode/typens:UniqueName"/>
							</TAX_CODE>
							<!--Use new field AdjustedCostInERPPrecision whenever supplied-->	
							<xsl:variable name="v_FinalAmt">
							<xsl:call-template name="ConsumeERPAmount">
								<xsl:with-param name="p_ERPAmt" select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
								<xsl:with-param name="p_Amt" select="typens:Amount/typens:Amount"/>
							</xsl:call-template>																
							</xsl:variable>							
							<xsl:variable name="v_ItemAmt">	
								<xsl:choose>
									<xsl:when test="starts-with(string($v_FinalAmt), '-')">
										<xsl:value-of select="$v_FinalAmt * -1.00"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$v_FinalAmt"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="v_NumberInCollection" select="typens:NumberInCollection"/>
							<ITEM_AMOUNT>
								<xsl:choose>
									<!--Amount Based PO : POLineReceivingType = '3'-->
									<!-- Begin of IG-17962 : Commenting logic as causing issues in ERP, to populate ITEM_AMOUNT based on POLineReceivingType = '3'-->
									<!--<xsl:when test="typens:POLineReceivingType = '3'">1.00</xsl:when>-->  
									<!-- End of IG-17962 : Commenting logic as causing issues in ERP, to populate ITEM_AMOUNT based on POLineReceivingType = '3'-->									
									<xsl:when test="$DiscountDetails/Item[@NumberInCollection = $v_NumberInCollection]">
										<!-- Discount-->
										<xsl:value-of select="format-number($DiscountDetails/Item[@NumberInCollection = $v_NumberInCollection]/Amount, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<!--No Discount-->
										<xsl:value-of select="format-number($v_ItemAmt, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</ITEM_AMOUNT>
							<xsl:variable name="v_ItemQty">
								<!--Remove negative value-->
								<xsl:choose>
									<xsl:when test="starts-with(string(typens:Quantity), '-')">
										<xsl:value-of select="typens:Quantity * -1.000"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="typens:Quantity"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<!-- Check is this Service Line, If yes Don't pass Quantity PO uint as blank, Else pass all details -->
								<xsl:when test="(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID 
									and ( not(exists(typens:OrderLineItem/typens:ERSAllowed)) or typens:OrderLineItem/typens:ERSAllowed = '' or typens:OrderLineItem/typens:ERSAllowed = 'false' ))
									or typens:OrderLineItem/typens:ServiceDetails/typens:NonSESBasedInvoice = 'true'">
									<QUANTITY>
										<xsl:value-of select="format-number(0, '0.000')"/>
									</QUANTITY>
									<PO_UNIT/>
									<PO_PR_UOM/>
								</xsl:when>
								<xsl:when test="(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID and typens:OrderLineItem/typens:ERSAllowed = 'true')">
									<QUANTITY>
										<xsl:value-of select="format-number( typens:Quantity, '0.000')"/>
									</QUANTITY>
									<PO_UNIT>
										<xsl:value-of select="typens:Description/typens:UnitOfMeasure/typens:UniqueName"/>
									</PO_UNIT>
									<PO_PR_UOM/>
								</xsl:when>
								<xsl:otherwise>
									<QUANTITY>
										<xsl:choose>
											<xsl:when test="typens:POLineReceivingType = '3'">
												<xsl:value-of select="format-number($v_ItemAmt * $v_ItemQty, '0.000')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($v_ItemQty, '0.000')"/>
											</xsl:otherwise>
										</xsl:choose>
									</QUANTITY>
									<PO_UNIT>
										<xsl:value-of select="typens:Description/typens:UnitOfMeasure/typens:UniqueName"/>
									</PO_UNIT>
									<PO_PR_UOM>
										<xsl:value-of select="typens:Description/typens:PriceBasisQuantityUOM/typens:UniqueName"/>
									</PO_PR_UOM>
								</xsl:otherwise>
							</xsl:choose>
							<SHEET_NO>
								<xsl:value-of select="typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID"/>
							</SHEET_NO>
							<ITEM_TEXT>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space(typens:Description/typens:Description)) > 50"> <!--<IG-37162 : XSLT Improvements>-->
										<xsl:value-of select="substring(typens:Description/typens:Description, 1, 50)"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring(typens:Description/typens:Description, 1, 50)"/> <!--IG-39684 : Payment Request ITEM_TEXT not Truncating to 50 Char-->
									</xsl:otherwise>
								</xsl:choose>
							</ITEM_TEXT>
							<SHEET_ITEM>
								<xsl:value-of select="typens:MatchedServiceSheetItem/typens:ServiceLineNumber"/>
							</SHEET_ITEM>
							<XBLNR>
								<xsl:value-of select="typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID"/>
							</XBLNR>
							<!--<CI-1014 - GR-based Invoice Verification in P2P (SAP Ariba Buying and Invoicing)-->
							<xsl:if test="((typens:OrderLineItem/typens:ERSAllowed = 'true' and not(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID))
								or (typens:GRBasedInvoice = 'true' and not(typens:MatchedServiceSheetItem/typens:Receipt/typens:ERPServiceSheetID)))">
							<!--<CI-1014 - GR-based Invoice Verification in P2P (SAP Ariba Buying and Invoicing)-->
								<xsl:variable name="v_erpReceiptDate" select="$v_matchedReceipt[typens:LineNumber = $v_NumberInCollection]/typens:MatchedReceiptItems/typens:item/typens:ReceiptItem/typens:ERPReceiptDate"/>
								<!-- Begin of IG-23105 : REF_DOC_DATE offset position fixed  - Can receive in 2 format YYYY-MM-DDTHH:MM:SSZ  OR YYYYMMDD-->
								<xsl:choose>
									<xsl:when test="string-length(normalize-space($v_erpReceiptDate)) > 8"> <!--<IG-37162 : XSLT Improvements >-->
										<REF_DOC_DATE>
											<xsl:value-of select="concat(substring($v_erpReceiptDate, 1,4), '-',
												substring($v_erpReceiptDate, 6, 2), '-',
												substring($v_erpReceiptDate, 9, 2))"/>
										</REF_DOC_DATE>
									</xsl:when>	
									<xsl:otherwise>	
										<REF_DOC_DATE>
											<xsl:value-of select="concat(substring($v_erpReceiptDate, 1,4), '-',
												substring($v_erpReceiptDate, 5, 2), '-',
												substring($v_erpReceiptDate, 7, 2))"/>
										</REF_DOC_DATE>
									</xsl:otherwise>	
								</xsl:choose>
								<!-- End of IG-23105 -->								
							</xsl:if>
						</item>
					</xsl:if>
				</xsl:for-each>
			</ITEMDATA>
			<!--<IG-37162 : XSLT Improvements, Rearranging tags >-->
			<!--Tax Data-->
			<TAXDATA>
				<xsl:variable name="v_TaxTempData">					
					<xsl:for-each select="$v_Tax">
						<xsl:variable name="v_TaxCode" select="typens:TaxCode/typens:UniqueName"/>
						<xsl:variable name="v_TaxAmtPrecision"
							select="typens:TaxAmountInERPPrecision/typens:Amount"/>
						<xsl:variable name="v_TaxAmt" select="typens:TaxAmount/typens:Amount"/>	
						<xsl:variable name="taxType">
							<xsl:value-of select="typens:TaxType/typens:UniqueName"/>
						</xsl:variable>																																	
						<item>
							<xsl:if test="$v_GlAccMain[typens:LineType/typens:Category !=64 and typens:ExpectedTax/typens:TaxCode/typens:UniqueName=$v_TaxCode]">	
								<xsl:attribute name="TAX_CODE">
									<xsl:value-of select="$v_TaxCode"/>
								</xsl:attribute>
								<TAX_AMOUNT>
									<!--Consume TaxAmountInERPPrecision when available-->
									<xsl:variable name="v_finalTaxAmt">
										<xsl:call-template name="ConsumeERPAmount">
											<xsl:with-param name="p_ERPAmt"
												select="$v_TaxAmtPrecision"/>
											<xsl:with-param name="p_Amt" select="$v_TaxAmt"/>
										</xsl:call-template>
									</xsl:variable>
									<!--Remove negative value-->
									<xsl:choose>
										<xsl:when test="starts-with(string($v_finalTaxAmt), '-')">
											<xsl:value-of select="$v_finalTaxAmt * -1.00"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$v_finalTaxAmt"/>
										</xsl:otherwise>
									</xsl:choose>
								</TAX_AMOUNT>
							</xsl:if>											
						</item>												
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each-group select="$v_TaxTempData/item" group-by="@TAX_CODE">
					<xsl:variable name="v_taxcode" select="@TAX_CODE"/>
					<item>
						<TAX_CODE>
							<xsl:value-of select="@TAX_CODE"/>
						</TAX_CODE>
						<xsl:if test="$v_TaxTempData/item[@TAX_CODE = $v_taxcode]/TAX_AMOUNT !=  '' ">
							<TAX_AMOUNT>
								<xsl:value-of select="format-number(sum($v_TaxTempData/item[@TAX_CODE = $v_taxcode]/TAX_AMOUNT), '0.00')"/>
							</TAX_AMOUNT>
						</xsl:if>
					</item>
				</xsl:for-each-group>
			</TAXDATA>			
			<!-- FI Non-PO Invoice Tax Code -->
			<xsl:if test="($v_fiindicator = 'TRUE' or $v_taxsource = 'ETE')">
				<xsl:if test="$v_payTaxExport">
					<T_INVTAX>
						<xsl:for-each select="$v_Tax">
							<xsl:variable name="v_TaxCode" select="typens:TaxCode/typens:UniqueName"/>
							<xsl:variable name="v_TaxAmtPrecision"
								select="typens:TaxAmountInERPPrecision/typens:Amount"/>
							<xsl:variable name="v_TaxAmt" select="typens:TaxAmount/typens:Amount"/>	
							<xsl:variable name="taxType">
								<xsl:value-of select="typens:TaxType/typens:UniqueName"/>
							</xsl:variable>																
							<item>
								<xsl:if test="$v_GlAccMain[typens:LineType/typens:Category !=64 and typens:ExpectedTax/typens:TaxCode/typens:UniqueName=$v_TaxCode]">	
									<REF_LINE_NUM>
										<xsl:value-of select="typens:ReferenceLineNumber"/>
									</REF_LINE_NUM>
									<INVOICE_DOC_ITEM>
										<xsl:value-of select="typens:ReferenceInvoiceLineNumber"/>
									</INVOICE_DOC_ITEM>	
									<TAX_AMOUNT>
										<!--Consume TaxAmountInERPPrecision when available-->
										<xsl:variable name="v_finalTaxAmt">
											<xsl:call-template name="ConsumeERPAmount">
												<xsl:with-param name="p_ERPAmt"
													select="$v_TaxAmtPrecision"/>
												<xsl:with-param name="p_Amt" select="$v_TaxAmt"/>
											</xsl:call-template>
										</xsl:variable>
										<!--Remove negative value. Also format the number (IG-18098)-->
										<xsl:choose>
											<xsl:when test="starts-with(string($v_finalTaxAmt), '-')">
												<xsl:value-of select="format-number($v_finalTaxAmt * -1.00,'0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($v_finalTaxAmt,'0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</TAX_AMOUNT>
								</xsl:if>
								<TAX_CODE>
									<xsl:value-of select="typens:TaxCode/typens:UniqueName"/>
								</TAX_CODE>
								<TAX_BASE_AMOUNT>
									<xsl:choose>
										<!--Remove negative value. Also format the number (IG-18098)-->
										<xsl:when test="starts-with(string(typens:TaxableAmount/typens:Amount), '-')">
											<xsl:value-of select="format-number(typens:TaxableAmount/typens:Amount * -1.00,'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(typens:TaxableAmount/typens:Amount,'0.00')"/>
										</xsl:otherwise>
									</xsl:choose>	
								</TAX_BASE_AMOUNT>
								<ITM_TEXT>
									<xsl:value-of select="typens:ReferenceLineDescription"/>
								</ITM_TEXT>
								<DB_CR_IND>
									<xsl:value-of select="typens:DBCRIndicator"/>
								</DB_CR_IND>
								<EXPECTED_TAX_RATE>
									<xsl:value-of
										select="format-number(typens:ExpectedTaxRate, '0.00')"/>
								</EXPECTED_TAX_RATE>
								<IS_DEDUCTIBLE>
									<xsl:value-of select="typens:IsDeductible"/>
								</IS_DEDUCTIBLE>
								<IS_ACCRUAL>
									<xsl:value-of select="typens:IsAccrual"/>
								</IS_ACCRUAL>
								<xsl:if test="typens:AccrualTaxAmount">	
									<ACCRUAL_TAX_AMOUNT>
										<xsl:choose>
											<xsl:when
												test="starts-with(string(typens:AccrualTaxAmount/typens:Amount), '-')">
												<xsl:value-of
													select="typens:AccrualTaxAmount/typens:Amount * -1.00"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="format-number(typens:AccrualTaxAmount/typens:Amount, '0.00')"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</ACCRUAL_TAX_AMOUNT>
								</xsl:if>	
								<SELLER_TAX_REGISTRATION_NUMBER>
									<xsl:value-of select="typens:SellerTaxRegistrationNumber"/>
								</SELLER_TAX_REGISTRATION_NUMBER>
								<BUYER_TAX_REGISTRATION_NUMBER>
									<xsl:value-of select="typens:BuyerTaxRegistrationNumber"/>
								</BUYER_TAX_REGISTRATION_NUMBER>
								<TAX_AUTHORITY>
									<xsl:value-of select="typens:TaxAuthority"/>
								</TAX_AUTHORITY>
								<ACCOUNT_INSTRUCTION>
									<xsl:value-of select="typens:AccountInstruction"/>
								</ACCOUNT_INSTRUCTION>
								<TAX_TYPE>
									<xsl:value-of select="typens:TaxType/typens:UniqueName"/>
								</TAX_TYPE>
								<TAX_ACCOUNT_KEY>
									<xsl:value-of select="typens:TaxAccountKey"/>
								</TAX_ACCOUNT_KEY>								
								<INVOICE_CITATION>
									<xsl:value-of select="typens:InvoiceCitation"/>
								</INVOICE_CITATION>
								<TAXJCD>
									<xsl:value-of select="typens:TaxJurisdiction"/>
								</TAXJCD>
							</item>
						</xsl:for-each>
					</T_INVTAX>
				</xsl:if>
			</xsl:if>			
			<!-- WithHolding Tax -->
			<WITHTAXDATA>
				<xsl:for-each select="$v_WithholdingData/item">
					<item>
						<SPLIT_KEY>
							<xsl:value-of select="'00001'"/>
						</SPLIT_KEY>
						<!--<IG-37162 : XSLT Improvements, Rearranging tags >-->
						<xsl:if test="uniqueid !=''">
							<!--If not Empty, and We need to call Template to Read PD entry for withholding tax type-->
							<WI_TAX_TYPE>
								<xsl:call-template name="ReadLookUpTable_In">
									<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
									<xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
									<xsl:with-param name="p_docType" select="$anSourceDocumentType"/>
									<xsl:with-param name="p_input" select="uniqueid"/>
									<xsl:with-param name="p_lookupName" select="'WithholdingTaxMap'"/>
									<xsl:with-param name="p_productType" select="'AribaProcurement'"/>
								</xsl:call-template>
							</WI_TAX_TYPE>
						</xsl:if>						
						<xsl:variable name="v_tax">
							<xsl:value-of select="TaxCode"/>
						</xsl:variable>
						<WI_TAX_CODE>							
							<xsl:value-of select="replace($v_tax,' ','')"/>
						</WI_TAX_CODE>
						<xsl:variable name="v_LineNo" select="LineNo"/>
						<xsl:variable name="v_WithTaxType">
							<xsl:value-of select="uniqueid"/>
						</xsl:variable>						
						<WI_TAX_BASE>
							<xsl:value-of select="format-number(sum($v_payTaxExport/typens:item[(typens:TaxCode/typens:UniqueName = $v_tax) and(upper-case(typens:TaxType/typens:UniqueName) = $v_WithTaxType)]/typens:TaxableAmount/typens:Amount),'0.00')"/>
						</WI_TAX_BASE>						
						<WI_TAX_AMT>
							<xsl:value-of select="format-number($v_WithholdingTaxAmmount/item[@LineNo = $v_LineNo]/Amount, '0.00')"/>
						</WI_TAX_AMT>
					</item>
				</xsl:for-each>
			</WITHTAXDATA> 
		</n0:ARBCIG_BAPI_INVOICE_CREATE>
	</xsl:template>
	<!--Template for GL Account Data-->
	<xsl:template name="GlAccountDataTempletIn">
		<item>
			<UNIQUEID>
				<xsl:value-of select="upper-case(../../../typens:LineType/typens:UniqueName)"/>
			</UNIQUEID>
			<ARIBA_PLANT>
				<xsl:value-of select="../../../typens:ShipTo/typens:UniqueName"/>
			</ARIBA_PLANT>
			<PO_NUMBER>
				<xsl:value-of select="../../../typens:ERPPONumber"/>
			</PO_NUMBER>
			<HDR_LEVEL>
				<xsl:choose>
					<xsl:when test="../../../typens:IsHeaderLevelLine = 'false'">
						<xsl:value-of select="'NO'"/>
					</xsl:when>
					<xsl:when test="../../../typens:IsHeaderLevelLine = 'true'">
						<xsl:value-of select="'YES'"/>
					</xsl:when>
				</xsl:choose>
			</HDR_LEVEL>
			<!--<IG-37162 : XSLT Improvements, Rearranging tags >-->
			<ASSET_NO>
				<xsl:value-of select="typens:Asset/typens:UniqueName"/>
			</ASSET_NO>
			<SUB_NUMBER>
				<xsl:value-of select="typens:Asset/typens:SubNumber"/>
			</SUB_NUMBER>
			<ARIBA_WBS_ELEM>
				<xsl:value-of select="typens:WBSElement/typens:UniqueName"/>
			</ARIBA_WBS_ELEM>			
			<CATEGORY>
				<xsl:value-of select="../../../typens:LineType/typens:Category"/>
			</CATEGORY>
			<INVOICE_DOC_ITEM>
				<xsl:value-of select="../../../typens:NumberInCollection"/>
			</INVOICE_DOC_ITEM>
			<GL_ACCOUNT>
				<xsl:value-of select="typens:GeneralLedger/typens:UniqueName"/>
			</GL_ACCOUNT>
			<xsl:variable name="v_GLAmt">
				<xsl:choose>
					<xsl:when test="exists(typens:AdjustedCostInERPPrecision/typens:Amount)">
						<xsl:choose>
							<xsl:when
								test="starts-with(string(typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
								<xsl:value-of
									select="typens:AdjustedCostInERPPrecision/typens:Amount * -1.00"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="starts-with(string(typens:Amount/typens:Amount), '-')">
								<xsl:value-of select="typens:Amount/typens:Amount * -1.00"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="typens:Amount/typens:Amount"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="v_NewNumberInCollection" select="concat(../../../typens:NumberInCollection,typens:NumberInCollection)"/>
			<ITEM_AMOUNT>
				<xsl:choose>
					<!-- Including LineType Category 4,8,16 to consider for Discount -->
					<xsl:when test="$DiscountDetails/Item[@NumberInCollection = $v_NewNumberInCollection]and (../../../typens:LineType/typens:Category = '1' or ../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16' or string-length(normalize-space(../../../typens:LineType/typens:Category)) = 0) "> <!--<IG-37162 : XSLT Improvements>-->
						<!-- Discount-->
						<xsl:value-of select="format-number($DiscountDetails/Item[@NumberInCollection = $v_NewNumberInCollection]/Amount, '0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number($v_GLAmt, '0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</ITEM_AMOUNT>
			<DB_CR_IND>
				<xsl:value-of select="../../../typens:DBCRIndicator"/>
			</DB_CR_IND>
			<COMP_CODE>
				<xsl:value-of select="../../../../../typens:CompanyCode/typens:UniqueName"/>
			</COMP_CODE>
			<TAX_CODE>
				<xsl:value-of select="../../../typens:ExpectedTax/typens:TaxCode/typens:UniqueName"/>
			</TAX_CODE>
			<ITEM_TEXT>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space(../../../typens:Description/typens:Description)) > 50"> <!--<IG-37162 : XSLT Improvements>-->
						<xsl:value-of select="substring(../../../typens:Description/typens:Description, 1, 50)"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring(../../../typens:Description/typens:Description, 1, 50)"/> <!--IG-39684 : Payment Request ITEM_TEXT not Truncating to 50 Char-->
					</xsl:otherwise>
				</xsl:choose>
			</ITEM_TEXT>
			<COSTCENTER>
				<xsl:value-of select="typens:CostCenter/typens:UniqueName"/>
			</COSTCENTER>
			<ORDERID>
				<xsl:value-of select="typens:InternalOrder/typens:UniqueName"/>
			</ORDERID>
			<FUNDS_CTR>
				<xsl:value-of select="typens:custom/typens:CustomFundsCenter/typens:UniqueName"/>
			</FUNDS_CTR>
			<FUND>
				<xsl:value-of select="typens:custom/typens:CustomFund/typens:UniqueName"/>
			</FUND>
			<!--IG-28021: Mapping Network and Activity for Account assignment -->
			<xsl:if test="string-length(normalize-space(typens:Network/typens:UniqueName)) > 0">
			<NETWORK>
				<xsl:value-of select="typens:Network/typens:UniqueName"/>
			</NETWORK>
			</xsl:if>
			<xsl:if test="string-length(normalize-space(typens:ActivityNumber/typens:UniqueName)) > 0">
			<ACTIVITY>
				<xsl:value-of select="typens:ActivityNumber/typens:UniqueName"/>
			</ACTIVITY>
			</xsl:if>
			<!--IG-28021: Mapping Network and Activity for Account assignment -->			
			<GRANT_NBR>
				<xsl:value-of select="typens:custom/typens:CustomGrant/typens:UniqueName"/>
			</GRANT_NBR>
			<CMMT_ITEM_LONG>
				<xsl:value-of select="typens:custom/typens:CustomCommitmentItem/typens:UniqueName"/>
			</CMMT_ITEM_LONG>
			<FUNC_AREA_LONG>
				<xsl:value-of select="typens:custom/typens:CustomFunctionalArea/typens:UniqueName"/>
			</FUNC_AREA_LONG>
			<BUDGET_PERIOD>
				<xsl:value-of select="typens:custom/typens:CustomBudgetPeriod/typens:UniqueName"/>
			</BUDGET_PERIOD>
			<CHARGE_FLAG>
				<xsl:value-of select="../../../typens:Parent/typens:NumberInCollection"/>
			</CHARGE_FLAG>
			<!--  Variable for split values-->
			<xsl:variable name="v_Percentage">
				<xsl:choose>
					<xsl:when test = "typens:AdjustedPercentageForSplits != 0">
						<xsl:value-of select = "typens:AdjustedPercentageForSplits"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="typens:Percentage != 0">
								<xsl:value-of select = "typens:Percentage"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="00.0"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>    
			</xsl:variable>    
			<!-- End of variable allocation-->
			<!--Below variable percentage is changed to v_percentage-->
			<DISTR_PERC>
				<xsl:value-of select="format-number(number(translate($v_Percentage, '-', '')), '00.0')"/>
			</DISTR_PERC>
			<!--IG-20194-->
			<ARIBA_ITEM_NO>
				<xsl:value-of select="typens:NumberInCollection"/>
			</ARIBA_ITEM_NO>
			<!--IG-20194-->
		</item>
	</xsl:template>
	<!--Template for calucate Discount on each line and create a table-->
	<xsl:template name="DiscountedAmounts">
		<xsl:param name="p_tableName"/>
		<xsl:param name="p_ItemDis"/>
		<!--Get all coresponding Line details Link NumberInCollection,Quantity , Amount-->
		<xsl:variable name="v_AmtSum">
			<xsl:choose>
				<!--PO Based Header Level discount to loop ItemData table-->
				<xsl:when test="$p_tableName = 'ItemData'">
					<xsl:for-each select="$v_ItemData">
						<xsl:choose>
							<xsl:when test="typens:LineType/typens:Category = '1'">
								<value>
									<xsl:attribute name="NumberInCollection">
										<xsl:value-of select="typens:NumberInCollection"/>
									</xsl:attribute>
									<xsl:attribute name="Quantity">
										<!--Get main Line Quantity for calucation in Accounting Data, convert to Positive-->
										<xsl:choose>
											<xsl:when test="starts-with(string(typens:Quantity), '-')">
												<xsl:value-of select="typens:Quantity * -1.000"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="typens:Quantity"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<amount>
								 <!--Consume ERPPrecision Value-->
										<xsl:variable name="v_AdjERPAmt">
											<xsl:call-template name="ConsumeERPAmount">
												<xsl:with-param name="p_ERPAmt" select="typens:AdjustedCostInERPPrecision/typens:Amount"/>
												<xsl:with-param name="p_Amt" select = "typens:Amount/typens:Amount"/>
											</xsl:call-template>
										</xsl:variable>
										<!--Get main Line Amount for Discount calculation, convert to Positive-->
										<xsl:choose>
											<xsl:when test="starts-with(string($v_AdjERPAmt), '-')">
												<xsl:value-of select="format-number($v_AdjERPAmt * -1.00, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($v_AdjERPAmt, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</amount>
								</value>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<!--Non-PO Based Header Level discount-->
				<xsl:when test="$p_tableName = 'GLData'">
					<xsl:for-each select="$v_GlAcc">
						<xsl:choose>
							<!-- Including LineType Category 4,8,16 to consider for Discount -->
							<xsl:when test="((../../../typens:LineType/typens:Category = '1' or ../../../typens:LineType/typens:Category = '4' or ../../../typens:LineType/typens:Category = '8' or ../../../typens:LineType/typens:Category = '16' or string-length(normalize-space(../../../typens:LineType/typens:Category)) = 0) and not(exists(../../../typens:Parent/typens:NumberInCollection)))"> <!--<IG-37162 : XSLT Improvements >-->
								<value>
									<!--Concate main Line 'NumberInCollection' with split Account 'NumberInCollection' to make Unique-->
									<xsl:attribute name="NumberInCollection">
										<xsl:value-of select="concat(../../../typens:NumberInCollection,typens:NumberInCollection)"/>
									</xsl:attribute>
									<!--Get main Line Amount for Discount calculation, convert to Positive-->
									<amount>
										<xsl:choose>
											<xsl:when
												test="exists(typens:AdjustedCostInERPPrecision/typens:Amount)">
												<xsl:choose>
													<xsl:when
														test="starts-with(string(typens:AdjustedCostInERPPrecision/typens:Amount), '-')">
														<xsl:value-of
															select="(typens:AdjustedCostInERPPrecision/typens:Amount * -1)"
														/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of
															select="typens:AdjustedCostInERPPrecision/typens:Amount"
														/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when
														test="starts-with(string(typens:Amount/typens:Amount), '-')">
														<xsl:value-of
															select="(typens:Amount/typens:Amount * -1)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="typens:Amount/typens:Amount"
														/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</amount>
								</value>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--Call Template to Calculate Discounted amount-->
		<xsl:call-template name="CalculateDiscount">
			<xsl:with-param name="p_AmtSum" select="$v_AmtSum"/>
			<xsl:with-param name="p_ItemDis" select="$p_ItemDis"/>
		</xsl:call-template>
	</xsl:template>
	<!--Template for caluculate Discount for Each Lines-->
	<xsl:template name="CalculateDiscount">
		<xsl:param name="p_AmtSum"/>
		<xsl:param name="p_ItemDis"/>
		<xsl:variable name="TotalAmount" select="sum($p_AmtSum/value/amount)"/>
		<xsl:variable name="LastNumberInCollection" select="max($p_AmtSum/value/@NumberInCollection)"/>
		<xsl:variable name="TotalAmountExceptLastItem">
			<xsl:for-each select="$p_AmtSum/value">
				<xsl:if test="@NumberInCollection != $LastNumberInCollection">
					<Item>
						<xsl:attribute name="NumberInCollection" select="@NumberInCollection"/>
						<Amount>
							<xsl:value-of select="format-number(amount - ($p_ItemDis * (amount div $TotalAmount)), '0.00')"/>
						</Amount>
					</Item>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="$p_AmtSum/value">
			<xsl:choose>
				<!--Line Level amount after discount Except Last Line-->
				<xsl:when test="@NumberInCollection != $LastNumberInCollection">
					<xsl:variable name="v_NumberInCollection" select="@NumberInCollection"/>
					<Item>
						<xsl:attribute name="NumberInCollection">
							<xsl:value-of select="@NumberInCollection"/>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="@Quantity"/>
						</xsl:attribute>
						<Amount>
							<xsl:value-of select="format-number($TotalAmountExceptLastItem/Item[@NumberInCollection = $v_NumberInCollection ]/Amount, '0.00')"/>
						</Amount>
					</Item>
				</xsl:when>
				<!-- Line Level amount after discount for Last Line -->
				<xsl:when test="@NumberInCollection = $LastNumberInCollection">
					<Item>
						<xsl:attribute name="NumberInCollection">
							<xsl:value-of select="$LastNumberInCollection"/>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="$p_AmtSum/value[@NumberInCollection = $LastNumberInCollection]/@Quantity"/>
						</xsl:attribute>
						<Amount>
							<xsl:value-of select="format-number(($TotalAmount - sum($TotalAmountExceptLastItem/Item/Amount) - number($p_ItemDis)), '0.00')"/>
						</Amount>
					</Item>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="VlaidateWithHoldingTax">
		<xsl:param name="p_TaxCode"/>
			<xsl:for-each select="$v_WithholdingData/item">
				<xsl:choose>
					<xsl:when test="TaxCode = $p_TaxCode">
						<xsl:value-of select="'TRUE'"/>
					</xsl:when>					
				</xsl:choose>
			</xsl:for-each>		
	</xsl:template>
	<!--Subsequent Credit/Debit Memo Logic-->
	<xsl:template name="ValidatePriceChangeType">
		<xsl:choose>
		<xsl:when
			test="$v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:IsPriceAdjustmentInvoice = 'true'">
			<xsl:choose>
			<!--Assign SAP Document type for subsequent debit document.-->
				<xsl:when
					test="$v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:InvoicePurpose = 'lineLevelDebitMemo'">
							<xsl:value-of select="'SDB'"/>								
				</xsl:when>
			<!--Assign SAP Document type for subsequent credit memo document-->
				<xsl:when
					test="$v_Header/typens:InvoiceReconciliation/typens:Invoice/typens:InvoicePurpose = 'lineLevelCreditMemo'">
							<xsl:value-of select="'SCR'"/>								
				</xsl:when>
			</xsl:choose>
		</xsl:when>	
			<!--Or , if this is normal document type , assign INV for Invoice / Credit memo-->
		<xsl:otherwise>
			<xsl:value-of select="'INV'"/>
		</xsl:otherwise>	
		</xsl:choose>
	</xsl:template>
		<!--Use this template to Read ERP Precision fields whenever supplied-->
	<xsl:template name="ConsumeERPAmount">
		<xsl:param name="p_ERPAmt"/>
		<xsl:param name="p_Amt"/>
		<xsl:choose>
			<xsl:when test="$p_ERPAmt != 0">
				<xsl:value-of select="$p_ERPAmt"/>
			</xsl:when>
			<xsl:when test="$p_Amt != 0">
				<xsl:value-of select="$p_Amt"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0.00"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
</xsl:stylesheet>
