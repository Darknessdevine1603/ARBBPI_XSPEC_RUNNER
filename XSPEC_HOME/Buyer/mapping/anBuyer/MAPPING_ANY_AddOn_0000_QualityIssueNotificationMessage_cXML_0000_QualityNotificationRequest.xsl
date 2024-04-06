<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>	-->
	<xsl:param name="anIsMultiERP"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anTargetDocumentType"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:variable name="v_pd">
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
			<xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_defaultLang">
		<xsl:call-template name="FillDefaultLang">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_timezone">
		<xsl:choose>
			<xsl:when test="string-length(/n0:QualityIssueNotificationMessage/QualityIssueNotification/UserTimezone) > 0">
				<xsl:value-of select="/n0:QualityIssueNotificationMessage/QualityIssueNotification/UserTimezone"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$anERPTimeZone"/>
			</xsl:otherwise>
		</xsl:choose>				
	</xsl:variable>
	<xsl:template match="/n0:QualityIssueNotificationMessage">
		<xsl:variable name="v_header"
			select="/n0:QualityIssueNotificationMessage/QualityIssueNotification"/>
		<xsl:variable name="v_item"
			select="/n0:QualityIssueNotificationMessage/QualityIssueNotification/Item"/>
		<Combined>
			<Payload>
				<cXML>
					<xsl:attribute name="payloadID">
						<xsl:value-of select="$anPayloadID"/>
					</xsl:attribute>
					<xsl:attribute name="timestamp">
						<xsl:value-of
							select="concat(substring(string(current-date()), 1, 10), 'T', substring(string(current-time()), 1, 8), $v_timezone)"
						/>
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
								<Identity>
									<xsl:value-of select="'CIG'"/>
								</Identity>
							</Credential>
						</From>
						<To>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'VendorID'"/></xsl:attribute>
								<Identity>
									<xsl:value-of select="$v_header/VendorParty/InternalID"/>
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
						<QualityNotificationRequest>
							<QualityNotificationRequestHeader>
								<xsl:attribute name="requestID">
									<xsl:choose>
										<xsl:when
											test="string-length(normalize-space($v_header/ExternalQualityIssueNotificationReference/ID)) > 0">
											<xsl:value-of
												select="$v_header/ExternalQualityIssueNotificationReference/ID"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$v_header/ID"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:attribute name="externalRequestID">
									<xsl:value-of select="$v_header/ID"/>
								</xsl:attribute>
								<xsl:attribute name="requestDate">
									<xsl:call-template name="ANDateTime">
										<xsl:with-param name="p_date">
											<xsl:value-of select="translate((substring-before($v_header/ReportedDateTime, 'T')), '-', '')"/>
										</xsl:with-param>
										<xsl:with-param name="p_time">
											<xsl:value-of select="translate((substring-after($v_header/ReportedDateTime, 'T')), ':', '')"/>
										</xsl:with-param>
										<xsl:with-param name="p_timezone">
											<xsl:value-of select="$v_timezone"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="operation">
									<xsl:choose>
										<xsl:when test="$v_header/ActionCode = '01'">
											<xsl:value-of select="'new'"/>
										</xsl:when>
										<xsl:when test="$v_header/ActionCode = '02'">
											<xsl:value-of select="'update'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<xsl:variable name="v_stat">
								<xsl:for-each select="$v_header/StatusObject/SystemStatus">
									<xsl:choose>
										<xsl:when
											test="Code = 'I0076' and ActiveIndicator = 'true'">
											<xsl:value-of select="'true'"/>
										</xsl:when>	
									</xsl:choose>
								</xsl:for-each>
								</xsl:variable>
								<xsl:attribute name="status">
									<xsl:for-each select="$v_header/StatusObject/SystemStatus">
										<xsl:choose>
											<xsl:when
												test="Code = 'I0076' and ActiveIndicator = 'true'"
												><xsl:value-of select="'canceled'"/></xsl:when>											
											<xsl:when
												test="Code = 'I0068' and ActiveIndicator = 'true'"
												><xsl:value-of select="'new'"/></xsl:when>
											<xsl:when
												test="Code = 'I0070' and ActiveIndicator = 'true'"
												><xsl:value-of select="'in-process'"/></xsl:when>
											<xsl:when
												test="Code = 'I0072' and ActiveIndicator = 'true'" >
												<xsl:if test="$v_stat != 'true'">
													<xsl:value-of select="'closed'"/></xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</xsl:attribute>
								<xsl:attribute name="discoveryDate">
									<xsl:call-template name="ANDateTime">
										<xsl:with-param name="p_date">
											<xsl:value-of select="translate((substring-before($v_header/ReportedDateTime, 'T')), '-', '')"/>
										</xsl:with-param>
										<xsl:with-param name="p_time">
											<xsl:value-of select="translate((substring-after($v_header/ReportedDateTime, 'T')), ':', '')"/>
										</xsl:with-param>
										<xsl:with-param name="p_timezone">
											<xsl:value-of select="$v_timezone"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:if test="string-length(normalize-space($v_header/Material/SerialID)) > 0">
									<xsl:attribute name="serialNumber">
										<xsl:value-of select="$v_header/Material/SerialID"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="returnDate">
									<xsl:call-template name="ANDateTime">					
										<xsl:with-param name="p_date">
											<xsl:value-of select="concat(substring($v_header/ReturnDate, 1, 4), substring($v_header/ReturnDate, 6, 2), substring($v_header/ReturnDate, 9, 2))"/>
										</xsl:with-param>
										<xsl:with-param name="p_time">
											<xsl:value-of select="'000000'"/>
										</xsl:with-param>
										<xsl:with-param name="p_timezone">
											<xsl:value-of select="$v_timezone"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:if
									test="string-length(normalize-space(QualityIssueNotification/MaterialInspectionReference/ID)) > 0">
									<QualityInspectionRequestReference>
										<xsl:attribute name="inspectionID">
											<xsl:value-of
												select="QualityIssueNotification/MaterialInspectionReference/ID"
											/>
										</xsl:attribute>
									</QualityInspectionRequestReference>
								</xsl:if>
								<xsl:if test="string-length(normalize-space($v_header/TypeCode)) > 0">
									<QNCode>
										<xsl:attribute name="domain">
											<xsl:value-of select="'type'"/>
										</xsl:attribute>
										<xsl:attribute name="codeGroup">
											<xsl:value-of select="$v_header/CodeGroup"/>
										</xsl:attribute>
										<xsl:attribute name="code">
											<xsl:value-of select="$v_header/TypeCode"/>
										</xsl:attribute>
										<xsl:attribute name="codeDescription">
											<xsl:value-of
												select="$v_header/TypeCode/@listAgencySchemeID"/>
										</xsl:attribute>
									</QNCode>
								</xsl:if>
								<xsl:if test="string-length(normalize-space($v_header/IssueParentQualityIssueCategoryID)) > 0">
									<QNCode>
										<xsl:attribute name="domain">
											<xsl:value-of select="'subject'"/>
										</xsl:attribute>
										<xsl:attribute name="codeGroup">
											<xsl:value-of
												select="$v_header/IssueParentQualityIssueCategoryID"
											/>
										</xsl:attribute>
										<xsl:attribute name="codeGroupDescription">
											<xsl:value-of
												select="$v_header/IssueParentQualityIssueCategoryID/@schemeAgencyID"
											/>
										</xsl:attribute>
										<xsl:attribute name="code">
											<xsl:value-of
												select="$v_header/IssueQualityIssueCategoryID"/>
										</xsl:attribute>
										<xsl:attribute name="codeDescription">
											<xsl:value-of
												select="$v_header/IssueQualityIssueCategoryID/@schemeAgencyID"
											/>
										</xsl:attribute>
									</QNCode>
								</xsl:if>
								<xsl:if test="$v_header/Material/PlantID">
									<Contact>
										<xsl:attribute name="role">
											<xsl:value-of select="'buyerParty'"/>
										</xsl:attribute>
										<xsl:attribute name="addressID">
											<xsl:value-of select="$v_header/Material/PlantID"/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">
											<xsl:value-of select="'buyerLocationID'"/>
										</xsl:attribute>
										<Name>
											<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="$v_header/Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
											</xsl:call-template>
											<xsl:value-of select="$v_header/Material/PlantID"/>
										</Name>
										<xsl:if
											test="string-length(normalize-space($v_header/BuyerParty/Contact)) > 0">										
										<PostalAddress>
											<!-- IG-32161 Defect fix typo DeliverTo to Deliverto  -->
											<xsl:if test="string-length(normalize-space($v_header/BuyerParty/Contact/Deliverto)) > 0"> 											
											<DeliverTo>
												<xsl:value-of select="$v_header/BuyerParty/Contact/Deliverto"/>
											</DeliverTo>
											</xsl:if>
											<Street>
												<xsl:value-of select="$v_header/BuyerParty/Contact/Street"/>												
											</Street>
											<City>
												<xsl:attribute name="cityCode">
													<xsl:value-of select="$v_header/BuyerParty/Contact/City/@cityCode"/>
												</xsl:attribute>												
												<xsl:value-of select="$v_header/BuyerParty/Contact/City"/>												
											</City>
											<State>
												<xsl:attribute name="isoStateCode">
													<xsl:value-of select="$v_header/BuyerParty/Contact/City/@isoStateCode"/>													
												</xsl:attribute>
												<xsl:value-of select="$v_header/BuyerParty/Contact/State"/>												
											</State>
											<Country>
												<xsl:attribute name="isoCountryCode">
													<xsl:value-of select="$v_header/BuyerParty/Contact/Country/@isoCountryCode"/>														
												</xsl:attribute>
												<xsl:value-of select="$v_header/BuyerParty/Contact/Country"/>												
											</Country>
										</PostalAddress>
										</xsl:if>
											<IdReference>
											<xsl:attribute name="identifier">
												<xsl:value-of select="$v_header/Material/PlantID"/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:value-of select="'buyerParty'"/>
											</xsl:attribute>
											<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="$v_header/Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of
												select="$v_header/Material/PlantID/@schemeAgencyID"
												/>
											</Description>
										</IdReference>
									</Contact>
								</xsl:if>
								<QNNotes>
									<xsl:attribute name="user">
										<xsl:choose>
											<xsl:when test="(string-length(normalize-space($v_header/SystemAdministrativeData/LastChangeUserAccountID)) > 0)">
												<xsl:value-of select="$v_header/SystemAdministrativeData/LastChangeUserAccountID"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="$v_header/SystemAdministrativeData/CreationUserAccountID"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="createDate">
										<xsl:call-template name="ANDateTime">
											<xsl:with-param name="p_date">
												<xsl:choose>
													<xsl:when test="(string-length(normalize-space($v_header/LastChangeDateTime)) > 0)">
														<xsl:value-of select="translate((substring-before($v_header/LastChangeDateTime, 'T')), '-', '')"/>														
													</xsl:when>
													<xsl:when test="(string-length(normalize-space($v_header/createDate)) > 0)">
														<xsl:value-of select="translate((substring-before($v_header/createDate, 'T')), '-', '')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="translate((substring-before($v_header/ReportedDateTime, 'T')), '-', '')"/>													
													</xsl:otherwise>
												</xsl:choose>
											</xsl:with-param>
											<xsl:with-param name="p_time">
												<xsl:choose>
													<xsl:when test="(string-length(normalize-space($v_header/LastChangeDateTime)) > 0)">
														<xsl:value-of select="translate((substring-after($v_header/LastChangeDateTime, 'T')), ':', '')"/>														
													</xsl:when>
													<xsl:when test="(string-length(normalize-space($v_header/createDate)) > 0)">
														<xsl:value-of select="translate((substring-after($v_header/createDate, 'T')), ':', '')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="translate((substring-after($v_header/ReportedDateTime, 'T')), ':', '')"/>													
													</xsl:otherwise>
												</xsl:choose>
											</xsl:with-param>
											<xsl:with-param name="p_timezone">
												<xsl:value-of select="$v_timezone"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:if
										test="((string-length(normalize-space($v_header/DetailedText)) > 0) or (string-length(normalize-space($v_header/Description)) > 0))">
										<Description>
											<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="$v_header/Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
											</xsl:call-template>
											<xsl:value-of select="$v_header/DetailedText"/>
											<ShortName>
												<xsl:value-of select="$v_header/Description"/>
											</ShortName>
										</Description>
									</xsl:if>
									<xsl:call-template name="addContenId">
										<xsl:with-param name="eachAtt" select="Attachment/Item"/>
									</xsl:call-template>
									<!-- CI-2361 add URL as attachment -->
									<xsl:variable name="eachAtt" select="$v_header/URLAttachment/Item"/>
									<xsl:for-each select="$eachAtt">
										<Attachment>
											<URL>
												<xsl:attribute name="name" select="URLDescription"/>
												<xsl:value-of select="URL"/>
											</URL>
										</Attachment>							
									</xsl:for-each>
								</QNNotes>
								<Priority>
									<xsl:attribute name="level">
										<xsl:choose>
											<xsl:when test="string-length(normalize-space($v_header/ImportanceCode)) > 0">
												<xsl:value-of select="$v_header/ImportanceCode"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'1'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="$v_header/Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
										<ShortName>
											<xsl:value-of
												select="$v_header/ImportanceCode/@listAgencySchemeID"
											/>
										</ShortName>
									</Description>
								</Priority>
								<xsl:if 
									test="string-length(normalize-space($v_header/RequestedProcessingPeriod/StartDateTime)) > 0 or string-length(normalize-space($v_header/RequestedProcessingPeriod/EndDateTime)) > 0"> <!-- IG-30426 -->
									<RequestedProcessingPeriod>
										<Period>
											<xsl:attribute name="startDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate((substring-before($v_header/RequestedProcessingPeriod/StartDateTime, 'T')), '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate((substring-after($v_header/RequestedProcessingPeriod/StartDateTime, 'T')), ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$v_timezone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:attribute name="endDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate((substring-before($v_header/RequestedProcessingPeriod/EndDateTime, 'T')), '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate((substring-after($v_header/RequestedProcessingPeriod/EndDateTime, 'T')), ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$v_timezone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</Period>
									</RequestedProcessingPeriod>
								</xsl:if>
								<xsl:if
									test="string-length(normalize-space($v_header/MachineryMalfunctionPeriod/StartDateTime)) > 0">
									<MalfunctionPeriod>
										<Period>
											<xsl:attribute name="startDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate((substring-before($v_header/MachineryMalfunctionPeriod/StartDateTime, 'T')), '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate((substring-after($v_header/MachineryMalfunctionPeriod/StartDateTime, 'T')), ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$v_timezone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:attribute name="endDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate((substring-before($v_header/MachineryMalfunctionPeriod/EndDateTime, 'T')), '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate((substring-after($v_header/MachineryMalfunctionPeriod/EndDateTime, 'T')), ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$v_timezone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</Period>
									</MalfunctionPeriod>
								</xsl:if>
								<xsl:if
									test="(string-length(normalize-space($v_header/PurchaseOrderReference/ID)) > 0) and ($v_header/PurchaseOrderReference/ItemID != '00000')">
									<ReferenceDocumentInfo>
										<xsl:attribute name="lineNumber">
											<xsl:value-of
												select="$v_header/PurchaseOrderReference/ItemID"/>
										</xsl:attribute>
										<DocumentInfo>
											<xsl:attribute name="documentID">
												<xsl:value-of
												select="$v_header/PurchaseOrderReference/ID"/>
											</xsl:attribute>
											<xsl:attribute name="documentType">
												<xsl:value-of select="'PurchaseOrder'"/>
											</xsl:attribute>
										</DocumentInfo>
									</ReferenceDocumentInfo>
								</xsl:if>
								<ItemInfo>
									<xsl:attribute name="quantity">
										<xsl:choose>
											<xsl:when test="string-length(normalize-space($v_header/ComplaintQuantity)) > 0 ">
												<xsl:value-of select="$v_header/ComplaintQuantity"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'0.0'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<ItemID>
										<SupplierPartID>
											<xsl:choose>
												<xsl:when test="string-length(normalize-space($v_header/Material/SellerID)) > 0">
												<xsl:value-of select="$v_header/Material/SellerID"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="' '"/>
												</xsl:otherwise>
											</xsl:choose>
										</SupplierPartID>
										<BuyerPartID>
											<xsl:value-of select="$v_header/Material/InternalID"/>
										</BuyerPartID>
									</ItemID>
									<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="$v_header/Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
										<xsl:value-of
											select="$v_header/Material/InternalID/@schemeAgencyID"
										/>
										<ShortName>
											<xsl:value-of
												select="$v_header/Material/InternalID/@schemeAgencyID"
											/>
										</ShortName>
									</Description>
									<xsl:if test="(string-length(normalize-space($v_header/OutboundDeliveryReference/ID)) > 0) and ($v_header/OutboundDeliveryReference/ItemID != '00000')">
										<ReferenceDocumentInfo>
											<xsl:attribute name="lineNumber">
												<xsl:value-of
												select="$v_header/OutboundDeliveryReference/ItemID"
												/>
											</xsl:attribute>
											<DocumentInfo>
												<xsl:attribute name="documentID">
												<xsl:value-of
												select="$v_header/OutboundDeliveryReference/ID"/>
												</xsl:attribute>
												<xsl:attribute name="documentType">
													<xsl:value-of select="'ShipNoticeDocument'"/>
												</xsl:attribute>
											</DocumentInfo>
										</ReferenceDocumentInfo>
									</xsl:if>
									<UnitOfMeasure>
										<xsl:call-template name="UOMTemplate_Out">
											<xsl:with-param name="p_UOMinput"
												select="$v_header/ComplaintQuantity/@unitCode"/>
											<xsl:with-param name="p_anERPSystemID"
												select="$anERPSystemID"/>
											<xsl:with-param name="p_anSupplierANID"
												select="$anSupplierANID"/>
										</xsl:call-template>
									</UnitOfMeasure>
								</ItemInfo>
								<Batch>
									<BuyerBatchID>
										<xsl:choose>
											<xsl:when test="string-length(normalize-space($v_header/Batch/BuyerBatchID)) > 0">
												<xsl:value-of
													select="$v_header/Batch/BuyerBatchID"/>											
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="$v_header/Material/BatchID"/>
											</xsl:otherwise>
										</xsl:choose>							
									</BuyerBatchID>
									<SupplierBatchID>
										<xsl:choose>
											<xsl:when test="string-length(normalize-space($v_header/Batch/SupplierBatchID)) > 0">										
												<xsl:value-of
													select="$v_header/Batch/SupplierBatchID"/>	
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="$v_header/Material/BatchSellerID"/>
											</xsl:otherwise>		
										</xsl:choose>								
									</SupplierBatchID>
									<xsl:if test="string-length(normalize-space($v_header/Material/PlantID)) > 0">										
									<PropertyValuation>
										<PropertyReference>
											<IdReference>
												<xsl:attribute name="identifier">
													<xsl:value-of
														select="$v_header/Material/PlantID"/>
												</xsl:attribute>	
												<xsl:attribute name="domain">
													<xsl:value-of
														select="'buyerParty'"/>
												</xsl:attribute>													
											</IdReference>
										</PropertyReference>
									</PropertyValuation>	
									</xsl:if>
								</Batch>
								<xsl:if test="string-length(normalize-space($v_header/ComplaintQuantity)) > 0">
									<ComplainQuantity>
										<xsl:attribute name="quantity">
											<xsl:choose>
												<xsl:when test="string-length(normalize-space($v_header/ComplaintQuantity)) > 0">
												<xsl:value-of select="$v_header/ComplaintQuantity"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'0.0'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<UnitOfMeasure>
											<xsl:call-template name="UOMTemplate_Out">
												<xsl:with-param name="p_UOMinput"
												select="$v_header/ComplaintQuantity/@unitCode"/>
												<xsl:with-param name="p_anERPSystemID"
												select="$anERPSystemID"/>
												<xsl:with-param name="p_anSupplierANID"
												select="$anSupplierANID"/>
											</xsl:call-template>
										</UnitOfMeasure>
									</ComplainQuantity>
								</xsl:if>
								<xsl:if test="string-length(normalize-space($v_header/ReturnedQuantity)) > 0">
									<ReturnQuantity>
										<xsl:attribute name="quantity">
											<xsl:choose>
												<xsl:when test="string-length(normalize-space($v_header/ReturnedQuantity)) > 0">
												<xsl:value-of select="$v_header/ReturnedQuantity"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="'0.0'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<UnitOfMeasure>
											<xsl:call-template name="UOMTemplate_Out">
												<xsl:with-param name="p_UOMinput"
												select="$v_header/ReturnedQuantity/@unitCode"/>
												<xsl:with-param name="p_anERPSystemID"
												select="$anERPSystemID"/>
												<xsl:with-param name="p_anSupplierANID"
												select="$anSupplierANID"/>
											</xsl:call-template>
										</UnitOfMeasure>
									</ReturnQuantity>
								</xsl:if>
								<xsl:for-each select="$v_header/Task">
									<xsl:if test="ActionCode != '03'">
										<QualityNotificationTask>
											<xsl:attribute name="taskId">
												<xsl:value-of select="OrdinalNumberValue"/>
											</xsl:attribute>
											<xsl:attribute name="status">
												<xsl:choose>
												<!-- Add close status -->
												<xsl:when
												test="StatusObject/SystemStatus[Code = 'I0157' and ActiveIndicator = 'true']">
												<xsl:value-of select="'close'"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:for-each select="StatusObject/SystemStatus">
												<xsl:choose>
												<xsl:when
												test="Code = 'I0154' and ActiveIndicator = 'true'">
												<xsl:value-of select="'new'"/>
												</xsl:when>
												<xsl:when
												test="Code = 'I0155' and ActiveIndicator = 'true'">
												<xsl:value-of select="'in-process'"/>
												</xsl:when>
												<xsl:when
												test="Code = 'I0156' and ActiveIndicator = 'true'">
													<xsl:value-of select="'close'"/>
												</xsl:when>
												</xsl:choose>
												</xsl:for-each>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="completedDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate((substring-before(CompletionDateTime, 'T')), '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate((substring-after(CompletionDateTime, 'T')), ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$v_timezone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:attribute name="processorId">
												<xsl:value-of select="AssignedToInternalID"/>
											</xsl:attribute>
												<xsl:attribute name="processorName">
													<xsl:value-of select="processorName"/>	 <!--IG-41789-->											
											</xsl:attribute>
											<xsl:attribute name="processorType">
												<xsl:choose>
												<xsl:when test="AssignedToTypeCode = 'VN'">
													<xsl:value-of select="'supplier'"/>
												</xsl:when>
												<xsl:when test="AssignedToTypeCode = 'LF'">
													<xsl:value-of select="'supplier'"/>
												</xsl:when>
												<xsl:when test="AssignedToTypeCode = 'VU'">
													<xsl:value-of select="'customerUser'"/>
												</xsl:when>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="string-length(normalize-space(ParentQualityIssueCategoryID)) > 0">
												<QNCode>
												<xsl:attribute name="domain">
													<xsl:value-of select="'task'"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="ParentQualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="ParentQualityIssueCategoryID/@schemeAgencyID"
												/>
												</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of select="QualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="QualityIssueCategoryID/@schemeAgencyID"/>
												</xsl:attribute>
												</QNCode>
											</xsl:if>
											<xsl:if test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
												<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of select="DetailedText"/>
												<ShortName>
												<xsl:value-of select="Description"/>
												</ShortName>
												</Description>
												<!-- CI-2361 QNNotes for Header Task Text -->
												<QNNotes>
													<xsl:call-template name="DetailedText"/>	
												</QNNotes>
											</xsl:if>
											<xsl:if test="string-length(normalize-space(PlannedProcessingPeriod)) > 0">
												<Period>
												<xsl:attribute name="startDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(PlannedProcessingPeriod/StartDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(PlannedProcessingPeriod/StartDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(PlannedProcessingPeriod/EndDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(PlannedProcessingPeriod/EndDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												</Period>
											</xsl:if>
										</QualityNotificationTask>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="$v_header/Activity">
									<xsl:if test="ActionCode != '03'">
										<QualityNotificationActivity>
											<xsl:attribute name="activityId">
												<xsl:value-of select="OrdinalNumberValue"/>
											</xsl:attribute>
											<xsl:if test="string-length(normalize-space(ParentQualityIssueCategoryID)) > 0">
												<QNCode>
												<xsl:attribute name="domain">
													<xsl:value-of select="'activity'"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="ParentQualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="ParentQualityIssueCategoryID/@schemeAgencyID"
												/>
												</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of select="QualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="QualityIssueCategoryID/@schemeAgencyID"/>
												</xsl:attribute>
												</QNCode>
											</xsl:if>
											<xsl:if test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
												<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of select="DetailedText"/>
												<ShortName>
												<xsl:value-of select="Description"/>
												</ShortName>
												</Description>
												<!-- CI-2361 QNNotes for Header Activity Text -->
												<QNNotes>
													<xsl:call-template name="DetailedText"/>
												</QNNotes>
											</xsl:if>
											<xsl:if test="string-length(normalize-space(ProcessingPeriod)) > 0">
												<Period>
												<xsl:attribute name="startDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(ProcessingPeriod/StartDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(ProcessingPeriod/StartDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(ProcessingPeriod/EndDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(ProcessingPeriod/EndDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												</Period>
											</xsl:if>
										</QualityNotificationActivity>
									</xsl:if>
								</xsl:for-each>
							</QualityNotificationRequestHeader>
							<xsl:for-each select="$v_item">
								<xsl:if test="ActionCode != '03'"> <!-- IG-30210 -->
								<QualityNotificationRequestItem>
									<xsl:attribute name="defectId">
										<xsl:value-of select="OrdinalNumberValue"/>
									</xsl:attribute>
									<xsl:attribute name="defectCount">
										<xsl:value-of select="DefectNumberValue"/>
									</xsl:attribute>
									<xsl:if test="string-length(normalize-space(DefectTypeParentQualityIssueCategoryID)) > 0">
										<QNCode>
											<xsl:attribute name="domain">
												<xsl:value-of select="'defect'"/>
											</xsl:attribute>
											<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="DefectTypeParentQualityIssueCategoryID"/>
											</xsl:attribute>
											<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="DefectTypeParentQualityIssueCategoryID/@schemeAgencyID"
												/>
											</xsl:attribute>
											<xsl:attribute name="code">
												<xsl:value-of
												select="DefectTypeQualityIssueCategoryID"/>
											</xsl:attribute>
											<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="DefectTypeQualityIssueCategoryID/@schemeAgencyID"
												/>
											</xsl:attribute>
										</QNCode>
									</xsl:if>
									<xsl:if test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
										<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
											<xsl:value-of select="DetailedText"/>
											<ShortName>
												<xsl:value-of select="Description"/>
											</ShortName>
										</Description>
										<!-- CI-2361 QNNotes for Item Text -->
										<QNNotes>
											<xsl:call-template name="DetailedText"/>
										</QNNotes>
									</xsl:if>
									<xsl:if test="string-length(normalize-space(MaterialInternalID)) > 0">
										<AdditionalQNInfo>
											<xsl:attribute name="lineNumber">
												<xsl:value-of select="ID"/>
											</xsl:attribute>
											<ItemID>
												<SupplierPartID>
													<!-- IG-32161 Defect fix typo Material/SellerID  -->
												<xsl:choose>
													<xsl:when test="string-length(normalize-space($v_header/Material/SellerID)) > 0">
														<xsl:value-of select="$v_header/Material/SellerID"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="' '"/>
												</xsl:otherwise>
												</xsl:choose>
												</SupplierPartID>
												<!--CI-1626-->
												<xsl:if test="string-length(normalize-space(MaterialInternalID)) > 0">
												<BuyerPartID>
												<xsl:value-of
												select="MaterialInternalID"/>
												</BuyerPartID>
												</xsl:if>
												<!--CI-1626-->
											</ItemID>
											<!--CI-1626-->
											<xsl:if test="string-length(normalize-space(Batch/BuyerBatchID)) > 0">
												<Batch>												
													<BuyerBatchID>														
														<xsl:value-of
															select="Batch/BuyerBatchID"/>														
													</BuyerBatchID>												
												</Batch>
											</xsl:if>
											<!--CI-1626-->
										</AdditionalQNInfo>
									</xsl:if>
									<xsl:for-each select="Task">
										<xsl:if test="ActionCode != '03'">
											<QualityNotificationTask>
												<xsl:attribute name="taskId">
												<xsl:value-of select="OrdinalNumberValue"/>
												</xsl:attribute>
												<xsl:attribute name="status">
												<xsl:choose>
												<!-- Add close status -->
												<xsl:when
												test="StatusObject/SystemStatus[Code = 'I0157' and ActiveIndicator = 'true']">
												<xsl:value-of select="'close'"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:for-each select="StatusObject/SystemStatus">
												<xsl:choose>
												<xsl:when
												test="Code = 'I0154' and ActiveIndicator = 'true'"
												>
													<xsl:value-of select="'new'"/>
												</xsl:when>
												<xsl:when
												test="Code = 'I0155' and ActiveIndicator = 'true'"
												>
													<xsl:value-of select="'in-process'"/>
												</xsl:when>
												<xsl:when
												test="Code = 'I0156' and ActiveIndicator = 'true'"
													>
													<xsl:value-of select="'close'"/>
												</xsl:when>
												</xsl:choose>
												</xsl:for-each>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:attribute name="completedDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(CompletionDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(CompletionDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="completedBy">
													<xsl:value-of select="completedBy"/>
												</xsl:attribute>
												<xsl:attribute name="processorId">
												<xsl:value-of select="AssignedToInternalID"/>													
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(processorName)) > 0">
													<xsl:attribute name="processorName">
														<xsl:value-of select="processorName"/>												
													</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="processorType">
												<xsl:choose>
												<xsl:when test="AssignedToTypeCode = 'VN'"
												>
													<xsl:value-of select="'supplier'"/>
												</xsl:when>
												<xsl:when test="AssignedToTypeCode = 'LF'"
												>
													<xsl:value-of select="'supplier'"/>
												</xsl:when>
												<xsl:when test="AssignedToTypeCode = 'VU'"
												>
													<xsl:value-of select="'customerUser'"/>
												</xsl:when>
												</xsl:choose>
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(ParentQualityIssueCategoryID)) > 0">
												<QNCode>
												<xsl:attribute name="domain">
													<xsl:value-of select="'task'"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="ParentQualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="ParentQualityIssueCategoryID/@schemeAgencyID"
												/>
												</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of select="QualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="QualityIssueCategoryID/@schemeAgencyID"/>
												</xsl:attribute>
												</QNCode>
												</xsl:if>
												<xsl:if
													test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
												<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of select="DetailedText"/>
												<ShortName>
												<xsl:value-of select="Description"/>
												</ShortName>
												</Description>
													<!-- CI-2361 QNNotes for Item Task Text -->
													<QNNotes>
														<xsl:call-template name="DetailedText"/>
													</QNNotes>
												</xsl:if>
												<xsl:if test="string-length(normalize-space(PlannedProcessingPeriod)) > 0">
												<Period>
												<xsl:attribute name="startDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(PlannedProcessingPeriod/StartDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(PlannedProcessingPeriod/StartDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(PlannedProcessingPeriod/EndDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(PlannedProcessingPeriod/EndDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												</Period>
												</xsl:if>
											</QualityNotificationTask>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="Activity">
										<xsl:if test="ActionCode != '03'">
											<QualityNotificationActivity>
												<xsl:attribute name="activityId">
												<xsl:value-of select="OrdinalNumberValue"/>
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(ParentQualityIssueCategoryID)) > 0">
												<QNCode>
												<xsl:attribute name="domain"
												>
													<xsl:value-of select="'activity'"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="ParentQualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="ParentQualityIssueCategoryID/@schemeAgencyID"
												/>
												</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of select="QualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="QualityIssueCategoryID/@schemeAgencyID"/>
												</xsl:attribute>
												</QNCode>
												</xsl:if>
												<xsl:if
													test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
												<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of select="DetailedText"/>
												<ShortName>
												<xsl:value-of select="Description"/>
												</ShortName>
												</Description>
													<!-- CI-2361 QNNotes for Item Activity Text -->
													<QNNotes>
														<xsl:call-template name="DetailedText"/>
													</QNNotes>
												</xsl:if>
												<xsl:if test="string-length(normalize-space(ProcessingPeriod)) > 0">
												<Period>
												<xsl:attribute name="startDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(ProcessingPeriod/StartDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(ProcessingPeriod/StartDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date">
															<xsl:value-of select="translate((substring-before(ProcessingPeriod/EndDateTime, 'T')), '-', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_time">
															<xsl:value-of select="translate((substring-after(ProcessingPeriod/EndDateTime, 'T')), ':', '')"/>
														</xsl:with-param>
														<xsl:with-param name="p_timezone">
															<xsl:value-of select="$v_timezone"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												</Period>
												</xsl:if>
											</QualityNotificationActivity>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="Cause">
										<xsl:if test="ActionCode != '03'">
											<QualityNotificationCause>
												<xsl:attribute name="causeId">
												<xsl:value-of select="OrdinalNumberValue"/>
												</xsl:attribute>
												<xsl:if test="string-length(normalize-space(ParentQualityIssueCategoryID)) > 0">
												<QNCode>
												<xsl:attribute name="domain">
													<xsl:value-of select="'cause'"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroup">
												<xsl:value-of
												select="ParentQualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeGroupDescription">
												<xsl:value-of
												select="ParentQualityIssueCategoryID/@schemeAgencyID"
												/>
												</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of select="QualityIssueCategoryID"/>
												</xsl:attribute>
												<xsl:attribute name="codeDescription">
												<xsl:value-of
												select="QualityIssueCategoryID/@schemeAgencyID"/>
												</xsl:attribute>
												</QNCode>
												</xsl:if>
												<xsl:if
													test="((string-length(normalize-space(Description)) > 0) or (string-length(normalize-space(DetailedText)) > 0))">
												<Description>
												<xsl:call-template name="FillLangOut">
												<xsl:with-param name="p_spras_iso"
												select="Description/@languageCode"/>
												<xsl:with-param name="p_lang"
												select="$v_defaultLang"/>
												</xsl:call-template>
												<xsl:value-of select="DetailedText"/>
												<ShortName>
												<xsl:value-of select="Description"/>
												</ShortName>
												</Description>
													<!-- CI-2361 QNNotes for Item Cause Text -->
													<QNNotes>
														<xsl:call-template name="DetailedText"/>
													</QNNotes>
												</xsl:if>
											</QualityNotificationCause>
										</xsl:if>
									</xsl:for-each>
								</QualityNotificationRequestItem>
								</xsl:if>
							</xsl:for-each>
						</QualityNotificationRequest>
					</Request>
				</cXML>
			</Payload>
			<xsl:if test="Attachment/Item != ''">
				<xsl:call-template name="OutBoundAttach"/>
			</xsl:if>
		</Combined>
	</xsl:template>
	<!-- CI-2361 DetailedText Template -->
	<!-- Temaplate to map QNNotes -->
	<xsl:template name="DetailedText">
		
		<xsl:attribute name="user">
			<xsl:choose>
				<xsl:when test="(string-length(normalize-space(SystemAdministrativeData/LastChangeUserAccountID)) > 0)">
					<xsl:value-of select="SystemAdministrativeData/LastChangeUserAccountID"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="SystemAdministrativeData/CreationUserAccountID"/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:attribute>
		<xsl:attribute name="createDate">
			<xsl:call-template name="ANDateTime">
				<xsl:with-param name="p_date">
					<xsl:choose>
						<xsl:when
							test="(string-length(normalize-space(SystemAdministrativeData/LastChangeDateTime)) > 0)">
							<xsl:value-of
								select="translate((substring-before(SystemAdministrativeData/LastChangeDateTime, 'T')), '-', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="translate((substring-before(SystemAdministrativeData/CreationDateTime, 'T')), '-', '')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="p_time">
					<xsl:choose>
						<xsl:when
							test="(string-length(normalize-space(SystemAdministrativeData/LastChangeDateTime)) > 0)">
							<xsl:value-of
								select="translate((substring-after(SystemAdministrativeData/LastChangeDateTime, 'T')), ':', '')"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="translate((substring-after(SystemAdministrativeData/CreationDateTime, 'T')), ':', '')"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="p_timezone">
					<xsl:value-of select="$v_timezone"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:attribute>
		<Description>
			<xsl:call-template name="FillLangOut">
				<xsl:with-param name="p_spras_iso" select="Description/@languageCode"/>
				<xsl:with-param name="p_lang" select="$v_defaultLang"/>
			</xsl:call-template>
			<xsl:value-of select="DetailedText"/>
			<ShortName>
				<xsl:value-of select="Description"/>
			</ShortName>
		</Description>
	</xsl:template>
</xsl:stylesheet>
