<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="xs" version="2.0">
     <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
		<xsl:param name="anErrorCode"/>
		<xsl:param name="anErrorDescription"/>
		<xsl:param name="anAlternateSenderID"/>
		<xsl:param name="anDateTime"/>
		<xsl:param name="anSourceDocumentType"/>
		<xsl:param name="anERPDocumentType"/>
		<xsl:param name="anERPSystemID"/>
		<xsl:param name="anDocNumber"/>
		<xsl:param name="erpDocNumber"/>

    <xsl:template match="*">
	
        <n0:DocumentStatusUpdateRequest>
				<xsl:variable name="dateNow" select="current-dateTime()"/>

			<xsl:choose>
			<xsl:when test="string-length($erpDocNumber) = 0 ">
            <ERPDocumentNo>
                <xsl:value-of select="EventMessageHeader/SAP_ApplicationID"/>
            </ERPDocumentNo>
			<!--</xsl:when>
			<xsl:otherwise>
			<ERPDocumentNo>
                <xsl:value-of select="EventMessageHeader/SAP_ApplicationID"/>
            </ERPDocumentNo>
			</xsl:otherwise>
			</xsl:choose> -->
            <DocumentNo/>
            <DocumentType>
                <xsl:choose>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'Order'">
                    	<xsl:value-of select="'ARBCIG_ORDERS'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'InvoiceStatusUpdate'">
                    	<xsl:value-of select="'InvoiceStatusUpdateRequest'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'EnquiryOrder'">
                    	<xsl:value-of select="'ARBCIG_ORDENQ'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'PaymentProposal'">
                    	<xsl:value-of select="'PaymentProposalRequest'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'PaymentRemittanceRequest'">
                    	<xsl:value-of select="'ARBCIG_REMADV'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'Requisition'">
                    	<xsl:value-of select="'RequisitionDetailsRequest'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'ScheduleAgreementRelease'">
                    	<xsl:value-of select="'ARBCIG_DELINS'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'ServiceSheetResponse'">
                    	<xsl:value-of select="'ServiceEntrySheetResponse'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'CCInvoice'">
                    	<xsl:value-of select="'ARBCIG_FIDCC2'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'MMInvoice'">
                    	<xsl:value-of select="'ARBCIG_GSVERF'"/>
                    </xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'PaymentBatchRequest'">
                		<xsl:value-of select="'PaymentBatchRequest'"/>
                	</xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'PaymentRemittanceCancelStatusUpdate'">
                		<xsl:value-of select="'PaymentRemittanceCancelStatusUpdate'"/>
                	</xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'ProductActivityMessage'">
                    	<xsl:value-of select="'ProductActivityMessage'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'ReceiptRequest'">
                    	<xsl:value-of select="'ReceiptDetailRequest'"/>
                    </xsl:when>
                    <xsl:when test="EventMessageHeader/anSourceDocumentType = 'ShipNoticeRequest'">
                    	<xsl:value-of select="'DsptchdDelivNotifMsg'"/>
                    </xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'QualityInspectionDecisionMsg'">
                		<xsl:value-of select="'QualityInspectionDecisionMsg'"/>
                	</xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'QualityInspectionRequest'">
                		<xsl:value-of select="'QualityInspectionRequest'"/>
                	</xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'QualityIssueNotificationMessage'">
                		<xsl:value-of select="'QualityNotificationRequest'"/>
                	</xsl:when>
                	<xsl:when test="EventMessageHeader/anSourceDocumentType = 'ERPServiceEntrySheetRequest'">
                		<xsl:value-of select="'ERPServiceEntrySheetRequest'"/>
                	</xsl:when>
                    <!--<xsl:when test="EventMessageHeader/anSourceDocumentType = 'DocumentStatusUpdateRequest'">DsptchdDelivNotifMsg</xsl:when>-->
                </xsl:choose>
            </DocumentType>
            <LogicalSystem>
			     <xsl:value-of select="EventMessageHeader/anSystemID"/>
			</LogicalSystem>
            <Vendor>
                <xsl:value-of select="EventMessageHeader/SAP_Receiver"/>
            </Vendor>            
            <Date>
                <xsl:value-of select=" substring(EventMessageHeader/anDateTime,1,10)"/>
            </Date>
            <Time>
                <xsl:value-of select=" substring(EventMessageHeader/anDateTime,12,8)"/>
            </Time>
            <Status>
                <xsl:choose>
                    <xsl:when test="EventMessageHeader/anErrorCode ='200' or EventMessageHeader/anErrorCode = '201' or EventMessageHeader/anErrorCode ='202'">
                    	<xsl:value-of select="'ACCEPTED'"/>
                    </xsl:when>
                    <xsl:otherwise>
                    	<xsl:value-of select="'REJECTED'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </Status>
            <TimeZone>
                <xsl:value-of select=" substring(EventMessageHeader/anDateTime,21,7)"/>
            </TimeZone>
            <Comment>
                <Comment>
                    <xsl:attribute name="languageCode">
                    	<xsl:value-of select="'en'"/>
                    </xsl:attribute>
                    <xsl:value-of select="EventMessageHeader/anErrorDescription"/>
                </Comment>
            </Comment>
			
			</xsl:when>
			<!-- error scenario -->
			<xsl:otherwise>
			
			<ERPDocumentNo>
                <xsl:value-of select="$erpDocNumber"/>
            </ERPDocumentNo>
			<DocumentNo/>
			<DocumentType>
						<xsl:choose>
							<xsl:when test="$anSourceDocumentType = 'Order'">
								<xsl:value-of select="'ARBCIG_ORDERS'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'InvoiceStatusUpdate'">
								<xsl:value-of select="'InvoiceStatusUpdateRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'EnquiryOrder'">
								<xsl:value-of select="'ARBCIG_ORDENQ'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'PaymentProposal'">
								<xsl:value-of select="'PaymentProposalRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'PaymentRemittanceRequest'">
								<xsl:value-of select="'ARBCIG_REMADV'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'Requisition'">
								<xsl:value-of select="'RequisitionDetailsRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ScheduleAgreementRelease'">
								<xsl:value-of select="'ARBCIG_DELINS'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ServiceSheetResponse'">
								<xsl:value-of select="'ServiceEntrySheetResponse'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'CCInvoice'">
								<xsl:value-of select="'ARBCIG_FIDCC2'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'MMInvoice'">
								<xsl:value-of select="'ARBCIG_GSVERF'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'PaymentBatchRequest'">
								<xsl:value-of select="'PaymentBatchRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'PaymentRemittanceCancelStatusUpdate'">
								<xsl:value-of select="'PaymentRemittanceCancelStatusUpdate'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ProductActivityMessage'">
								<xsl:value-of select="'ProductActivityMessage'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ReceiptRequest'">
								<xsl:value-of select="'ReceiptDetailRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ShipNoticeRequest'">
								<xsl:value-of select="'DsptchdDelivNotifMsg'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'QualityInspectionDecisionMsg'">
								<xsl:value-of select="'QualityInspectionDecisionMsg'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'QualityInspectionRequest'">
								<xsl:value-of select="'QualityInspectionRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'QualityIssueNotificationMessage'">
								<xsl:value-of select="'QualityNotificationRequest'"/>
							</xsl:when>
							<xsl:when test="$anSourceDocumentType = 'ERPServiceEntrySheetRequest'">
								<xsl:value-of select="'ERPServiceEntrySheetRequest'"/>
							</xsl:when>
							<!--<xsl:when test="$anSourceDocumentType = 'DocumentStatusUpdateRequest'">DsptchdDelivNotifMsg</xsl:when>-->
							<xsl:otherwise>
								<xsl:value-of select="$anERPDocumentType"/>
							</xsl:otherwise>
						</xsl:choose>
					</DocumentType>
					<LogicalSystem>
						<xsl:value-of select="$anERPSystemID"/>
					</LogicalSystem>
					<!--Optional:-->
					<Vendor>
						<xsl:value-of select="$anAlternateSenderID"/>
					</Vendor>
					<Date>
						<xsl:choose>
							<xsl:when test="$anDateTime != ''">
								<xsl:value-of select=" substring($anDateTime,1,10)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-dateTime($dateNow, '[Y01]-[M01]-[D01]')"/>
							</xsl:otherwise>
						</xsl:choose>
					</Date>
					<Time>
						<xsl:choose>
							<xsl:when test="$anDateTime != ''">
								<xsl:value-of select=" substring($anDateTime,12,8)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-dateTime($dateNow, '[H01]:[M01]:[s01]')"/>
							</xsl:otherwise>
						</xsl:choose>
					</Time>
					<Status>
						<xsl:choose>
							<xsl:when test="$anErrorCode = '200' or $anErrorCode = '201' or $anErrorCode ='202'">
								<xsl:value-of select="'ACCEPTED'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'REJECTED'"/>
							</xsl:otherwise>
						</xsl:choose>
					</Status>
					<TimeZone>
						<xsl:value-of select=" substring($anDateTime,21,7)"/>
					</TimeZone>
					<!--Optional:-->
					<Comment>
						<!--1 or more repetitions:-->
						<Comment>
							<xsl:attribute name="languageCode">
								<xsl:value-of select="'en'"/>
							</xsl:attribute>
							<xsl:value-of select="$anErrorDescription"/>
						</Comment>
					</Comment>
					
			</xsl:otherwise>
			</xsl:choose>
			
        </n0:DocumentStatusUpdateRequest>
    </xsl:template>
</xsl:stylesheet>
