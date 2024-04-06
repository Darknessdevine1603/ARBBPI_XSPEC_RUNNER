<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	<xsl:param name="anIsMultiERP"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anTargetDocumentType"/>
	<xsl:param name="anEnvName"/>
<!--		<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/> 
	<xsl:variable name="v_pd">
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
			<xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
		</xsl:call-template>
	</xsl:variable> 
	<xsl:variable name="v_defaultLang_pd">
		<xsl:call-template name="FillDefaultLang">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_defaultLang">
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($v_defaultLang_pd)) > 0">
				<xsl:value-of select="$v_defaultLang_pd"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'en'"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:variable>		
	<xsl:variable name="upgradeDate">
		<xsl:variable name="crossrefparamLookup" select="document($v_pd)"/>
		<xsl:value-of select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anTargetDocumentType]/CIGAddOnUpgradeDate"/>
	</xsl:variable>	
	<xsl:template match="n0:InvoiceStatusUpdateRequest">
		<Combined>
			<Payload>	
				<cXML>
					<xsl:attribute name="payloadID">
						<xsl:value-of select="$anPayloadID"/>
					</xsl:attribute>
					<xsl:attribute name="timestamp">
						<xsl:variable name="curDate">
							<xsl:value-of select="current-dateTime()"/>
						</xsl:variable>
						<xsl:value-of select="concat(substring($curDate,1,19),substring($curDate,24,29))"/>
					</xsl:attribute>		    				
					<Header>
						<From>
							<xsl:call-template name="MultiERPTemplateOut">
								<xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
								<xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
							</xsl:call-template>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'NetworkID'"/>
								</xsl:attribute>
								<Identity>
									<xsl:value-of select="$anSupplierANID"/>
								</Identity>
							</Credential>
							<!--End Point Fix for CIG-->
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'EndPointID'"/>
								</xsl:attribute>
								<Identity>CIG</Identity>
							</Credential> 
						</From>
						<To>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'VendorID'"/>
								</xsl:attribute>
								<Identity>
									<xsl:value-of select="item/LIFNR"/>
								</Identity>
							</Credential>
						</To>
						<Sender>
							<Credential domain="NetworkID">
								<Identity>
									<xsl:value-of select="$anProviderANID"/>
								</Identity>
								<SharedSecret>
									<xsl:value-of select="$anSharedSecrete"/>  
								</SharedSecret>
							</Credential>
							<UserAgent>
								<xsl:value-of select="'Ariba Supplier'"/>
							</UserAgent>
						</Sender>
					</Header>
					<Request>
						<xsl:choose>
							<xsl:when test="$anEnvName='PROD'">
								<xsl:attribute name="deploymentMode">
									<xsl:value-of select="'production'"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="deploymentMode">
									<xsl:value-of select="'test'"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="item">
							<StatusUpdateRequest>
								<Status>
									<xsl:attribute name="code">
										<xsl:choose>
											<xsl:when test="(INVOICE_STATUS = 'rejected')">
												<xsl:value-of select="'423'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'200'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="text">
										<xsl:value-of select="'OK'"/>
									</xsl:attribute>
									<xsl:attribute name="xml:lang">											
										<xsl:value-of select="$v_defaultLang"/>
									</xsl:attribute>
								</Status>						
								<InvoiceStatus>
									<xsl:attribute name="type">
										<xsl:choose>
											<xsl:when test="INVOICE_STATUS ='canceled'">
												<xsl:value-of select="'rejected'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="INVOICE_STATUS"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>	
									<!--                                CI-1857 Payment due date-->    
									<xsl:if test="string-length(normalize-space(DUE_DATE)) > 0">								
										<xsl:variable name="v_invoicedueDate">
											<xsl:value-of select='translate(substring(DUE_DATE, 1, 10), "-","")'/>
										</xsl:variable>
										<xsl:attribute name="paymentNetDueDate">
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="$v_invoicedueDate"/>
												<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:if>								
									<xsl:choose>
										<xsl:when test="Comments[1]/Comment = 'MRKO'">
											<InvoiceIDInfo>												
												<xsl:attribute name="invoiceID">
													<xsl:value-of select="ERP_INV_NO"/>
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(DOC_DATE)) > 0">
													<xsl:variable name="v_invoiceDate">
														<xsl:value-of select='translate(substring(DOC_DATE, 1, 10), "-","")'/>
													</xsl:variable>
													<xsl:variable name="v_invoiceTime">
														<xsl:value-of select='translate(substring(DOC_TIME, 1, 8), ":","")'/>
													</xsl:variable>
													<xsl:attribute name="invoiceDate">
														<xsl:call-template name="ANDateTime">
															<xsl:with-param name="p_date" select="$v_invoiceDate"/>
															<xsl:with-param name="p_time" select="$v_invoiceTime"/>
															<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
											</InvoiceIDInfo>	
										</xsl:when>
										<xsl:when test="(substring-before(Comments/Comment[1], ':') = ('MRRL','MRNB')) and (DOC_DATE &lt; $upgradeDate)">
											<InvoiceIDInfo>												
												<xsl:attribute name="invoiceID">
													<xsl:value-of select="substring-after(Comments/Comment[1], ':')"/>
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(DOC_DATE)) > 0">
													<xsl:variable name="v_invoiceDate">
														<xsl:value-of select='translate(substring(DOC_DATE, 1, 10), "-","")'/>
													</xsl:variable>
													<xsl:variable name="v_invoiceTime">
														<xsl:value-of select='translate(substring(DOC_TIME, 1, 8), ":","")'/>
													</xsl:variable>
													<xsl:attribute name="invoiceDate">
														<xsl:call-template name="ANDateTime">
															<xsl:with-param name="p_date" select="$v_invoiceDate"/>
															<xsl:with-param name="p_time" select="$v_invoiceTime"/>
															<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
											</InvoiceIDInfo>	
										</xsl:when>										
										<xsl:otherwise>
											<InvoiceIDInfo>
												<xsl:attribute name="invoiceID">
													<xsl:choose>
														<xsl:when test="string-length(normalize-space(CXML_INVOICE_ID)) > 0">
															<xsl:value-of select="CXML_INVOICE_ID"/>															
														</xsl:when>
														<xsl:when test="string-length(normalize-space(INV_DOC_NO)) > 0">
															<xsl:value-of select="INV_DOC_NO"/>															
														</xsl:when>
													</xsl:choose>													
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(DOC_DATE)) > 0">
													<xsl:variable name="v_invoiceDate">
														<xsl:value-of select='translate(substring(DOC_DATE, 1, 10), "-","")'/>
													</xsl:variable>
													<xsl:variable name="v_invoiceTime">
														<xsl:value-of select='translate(substring(DOC_TIME, 1, 8), ":","")'/>
													</xsl:variable>
													<xsl:attribute name="invoiceDate">
														<xsl:call-template name="ANDateTime">
															<xsl:with-param name="p_date" select="$v_invoiceDate"/>
															<xsl:with-param name="p_time" select="$v_invoiceTime"/>
															<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
											</InvoiceIDInfo>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="((INVOICE_STATUS = 'paid') and (number(AMT_DOCCUR) &gt; 0.0))">
										<PartialAmount>
											<Money>
												<xsl:attribute name="currency">
													<xsl:value-of select="CURRENCY"/>
												</xsl:attribute>
												<xsl:value-of select="format-number(number(AMT_DOCCUR), '0.00')"/>
											</Money>
										</PartialAmount>
									</xsl:if>								
									<xsl:for-each select="Comments/Comment[not(substring(.,1,4) = ('MRRL','MRNB','MRKO'))]">
										<Comments>											
											<xsl:attribute name="xml:lang">
												<xsl:choose>
													<xsl:when test="string-length(normalize-space(@LANG)) > 0">
														<xsl:value-of select="@LANG"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$v_defaultLang"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:value-of select="."/>										
										</Comments>
									</xsl:for-each>
									<!--Call Template to fill Comments-->
									<xsl:if
										test="../AribaComment/Item/AribaLine/TextLine != '' or ../AribaComment/Item/TextDesc != '' ">
											<Comments>
													<xsl:call-template name="CommentsFillProxyOut">
														<xsl:with-param name="p_aribaComment" select="../AribaComment"/>
														<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
														<xsl:with-param name="p_pd" select="$v_pd"/>
														<xsl:with-param name="p_trans" select="'ISU'"/>
													</xsl:call-template>	
											</Comments>
									</xsl:if>																									
								</InvoiceStatus>						
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'Ariba.ERPInvoiceNumber'"/>
									</xsl:attribute>
									<xsl:value-of select="ERP_INV_NO"/>
								</Extrinsic>
							</StatusUpdateRequest>
						</xsl:for-each>
					</Request>			
				</cXML>
			</Payload>
						
		</Combined>
	</xsl:template>
</xsl:stylesheet>
