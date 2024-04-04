<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<!--	<xsl:variable name="crossrefparamLookup" select="document('ParameterCrossreference.xml')"/>
   <xsl:variable name="UOMLookup" select="document('UOMTemplate.xml')"/>-->
	<xsl:param name="anCrossRefFlag"/>
	<xsl:param name="anLookUpFlag"/>
	<xsl:param name="anUOMFlag"/>
	<xsl:param name="anLocalTesting"/>
	<xsl:param name="commentlevel_header" select="'HEADER'"/>
	<xsl:param name="commentlevel_line" select="'LINE'"/>
	<xsl:param name="commentlevel_service_line" select="'SERVICE'"/>
	<!-- Outbound MultiERP template -->
	<xsl:template name="MultiERPTemplateOut">
		<xsl:param name="p_anIsMultiERP"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:if test="upper-case($p_anIsMultiERP) = 'TRUE'">
			<Credential>
				<xsl:attribute name="domain">SystemID</xsl:attribute>
				<Identity>
					<xsl:value-of select="$p_anERPSystemID"/>
				</Identity>
			</Credential>
		</xsl:if>
	</xsl:template>
	<!-- UOM Template for inbound CIG to SAP -->
	<!-- This template will be used to map the lookup value of UOMValues from Ariba against Customer values maintained. -->
	<!-- Currently used in following XSLTs -->
	<!-- 	MAPPING_ANY_cXML_0000_ComponentConsumptionRequest_AddOn_0000_ComponentConsumptionRequest.xsl
			MAPPING_ANY_cXML_0000_ConfirmationRequest_AddOn_0000_OrderConfirmation.xsl
			MAPPING_ANY_cXML_0000_FIInvoiceDetailRequest_AddOn_0000_FIInvoice.xsl
			MAPPING_ANY_cXML_0000_InvoiceDetailRequest_AddOn_0000_Invoice.xsl
			MAPPING_ANY_cXML_0000_ProductReplenishmentMessage_AddOn_0000_ProductReplenishmentMessage.xsl
			MAPPING_ANY_cXML_0000_QualityNotificationRequest_AddOn_0000_QualityIssueNotificationMessage.xsl
			MAPPING_ANY_cXML_0000_ReceiptRequest_AddOn_0000_ComponentAcknowledgement.xsl
			MAPPING_ANY_cXML_0000_SalesOrderRequest_AddOn_0000_ReplenishmentOrderRequest.xsl
			MAPPING_ANY_cXML_0000_ServiceEntrySheet_AddOn_0000_ServiceSheet.xsl
			MAPPING_ANY_cXML_0000_ShipNoticeRequest_AddOn_0000_AdvanceShipmentNotice.xsl -->
	<!-- input: -->
	<!-- p_UOMinput			=	Input UOM Value from Ariba Network, -->
	<!-- p_anERPSystemID	=	Input ERP SystemID -->
	<!-- p_anSupplierANID	=	Input Buyer AribaNetworkID -->
	<!-- output:	Value of Look up is returned if found , else input value is mapped on to output. -->
	<xsl:template name="UOMTemplate_In">
		<xsl:param name="p_UOMinput"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anSupplierANID"/>
		<xsl:if test="$p_UOMinput != '' and $anUOMFlag = 'YES'">
			<!--constructing the UOM string-->
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('UOM_UOM', '_', $p_anERPSystemID)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:choose>
					<xsl:when test="$anLocalTesting ='YES'">
						<xsl:value-of
							select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/UOM.xml'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:variable>
			<!--calling the binary PD to get the UOM -->
			<xsl:variable name="UOMLookup" select="document($v_pd)"/>
			<xsl:choose>
				<xsl:when
					test="string-length($UOMLookup/UOM/ListOfItems/Item[AribaValue = $p_UOMinput]/CustomerValue) &gt; 0">
					<xsl:value-of
						select="upper-case($UOMLookup/UOM/ListOfItems/Item[AribaValue = $p_UOMinput]/CustomerValue)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$p_UOMinput"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!--  To accomodate if anUOMFlag is NO-->
		<xsl:if test="$p_UOMinput != '' and $anUOMFlag = 'NO'">
			<xsl:value-of select="$p_UOMinput"/>
		</xsl:if>
	</xsl:template>
	<!-- UOM Template for outbound  SAP to CIG -->
	<!-- This template will be used to map the customer lookup value maintained against Ariba UOMValues in CIG. -->
	<!-- Currently used in following XSLTs -->
	<!-- 	MAPPING_ANY_AddOn_0000_CCInvoice_cXML_0000_InvoiceDetailRequest.xsl
			MAPPING_ANY_AddOn_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl
			MAPPING_ANY_AddOn_0000_Order_cXML_0000_OrderRequest.xsl
			MAPPING_ANY_AddOn_0000_ProductActivityMessage_cXML_0000_ProductActivityMessage.xsl
			MAPPING_ANY_AddOn_0000_PurchaseRequisition_cXML_0000_PurchaseRequisitionRequest.xsl
			MAPPING_ANY_AddOn_0000_QualityInspectionDecisionMsg_cXML_0000_QualityInspectionDecisionRequest.xsl
			MAPPING_ANY_AddOn_0000_QualityInspectionRequest_cXML_0000_QualityInspectionRequest.xsl
			MAPPING_ANY_AddOn_0000_QualityIssueNotificationMessage_cXML_0000_QualityNotificationRequest.xsl
			MAPPING_ANY_AddOn_0000_ReceiptRequest_cXML_0000_ReceiptRequest.xsl
			MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl
			MAPPING_ANY_AddOn_0000_ShipNoticeRequest_cXML_0000_ShipNoticeRequest.xsl 
			MAPPING_ANY_AddOn_0000_ERPServiceEntrySheetRequest_cXML_0000_ServiceEntrySheet.xsl -->
	<!-- input: -->
	<!-- p_UOMinput			=	Input UOM Value from ERP, -->
	<!-- p_anERPSystemID	=	Input ERP SystemID -->
	<!-- p_anSupplierANID	=	Input Supplier AribaNetworkID -->
	<!-- output:	Value of Look up is returned if found , else input value is mapped on to output. -->
	<xsl:template name="UOMTemplate_Out">
		<xsl:param name="p_UOMinput"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anSupplierANID"/>
		<xsl:if test="$p_UOMinput != '' and $anUOMFlag = 'YES'">
			<!--constructing the UOM string-->
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('UOM_UOM', '_', $p_anERPSystemID)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:choose>
					<xsl:when test="$anLocalTesting ='YES'">
						<xsl:value-of
							select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/UOM.xml'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:variable>
			<!--calling the binary PD to get the UOM -->
			<xsl:variable name="UOMLookup" select="document($v_pd)"/>
			<xsl:choose>
				<xsl:when
					test="string-length($UOMLookup/UOM/ListOfItems/Item[CustomerValue = $p_UOMinput]/AribaValue) &gt; 0">
					<xsl:value-of
						select="upper-case($UOMLookup/UOM/ListOfItems/Item[CustomerValue = $p_UOMinput]/AribaValue)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$p_UOMinput"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!--  To accomodate if anUOMFlag is NO-->
		<xsl:if test="$p_UOMinput != '' and $anUOMFlag = 'NO'">
			<xsl:value-of select="$p_UOMinput"/>
		</xsl:if>
	</xsl:template>
	<!--Template for lookup table -->
	<xsl:template name="LookupTemplate">
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anSupplierANID"/>
		<xsl:param name="p_producttype"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_lookupname"/>
		<xsl:param name="p_input"/>
		<xsl:if test="$p_input != '' and $anLookUpFlag = 'YES'">
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('LOOKUPTABLE', '_', $p_anERPSystemID)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:choose>
					<xsl:when test="$anLocalTesting ='YES'">
						<xsl:value-of
							select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/LOOKUPTABLE.xml'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:variable>
			<!--calling the binary PD to get the lookup -->
			<xsl:variable name="Lookup" select="document($v_pd)"/>
			<xsl:choose>
				<xsl:when test="$p_lookupname = 'QuoteRequestMatchingType'">
					<xsl:if test="string-length($Lookup/LOOKUPTABLE/Parameter[DocumentType = $p_doctype and Name = $p_lookupname and ProductType = $p_producttype]/ListOfItems/Item[Value = $p_input]/Name) &gt; 0">
						<xsl:value-of select="$Lookup/LOOKUPTABLE/Parameter[DocumentType = $p_doctype and Name = $p_lookupname and ProductType = $p_producttype]/ListOfItems/Item[Value = $p_input]/Name"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="string-length($Lookup/LOOKUPTABLE/Parameter[DocumentType = $p_doctype and Name = $p_lookupname and ProductType = $p_producttype]/ListOfItems/Item[Name = $p_input]/Value) &gt; 0">
						<xsl:value-of select="$Lookup/LOOKUPTABLE/Parameter[DocumentType = $p_doctype and Name = $p_lookupname and ProductType = $p_producttype]/ListOfItems/Item[Name = $p_input]/Value"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
<!-- create S4 Date/Time to AN cXML Date/Time/Timezone Template -->
<!-- input  Date	: CCYY-MM-DD
            Time	: HH:MM:SS
            Timezone	: +HH:MM
      output     	: CCYY-MM-DDTHH:MM:SS+HH:MM	           
	-->
	<xsl:template name="ANDateTime_S4HANA">
		<xsl:param name="p_date"/>
		<xsl:param name="p_time"/>
		<xsl:param name="p_timezone"/>
		<xsl:choose>
			<xsl:when test="string-length($p_time) &gt; 0">
				<xsl:variable name="v_time">
					<xsl:value-of select="$p_time"/>
				</xsl:variable>
				<xsl:value-of select="concat($p_date, 'T', $v_time, $p_timezone)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="v_time">
					<xsl:value-of select="'12:00:00'"/>
				</xsl:variable>
				<xsl:value-of select="concat($p_date, 'T', $v_time, $p_timezone)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- AN Date Template -->
	<xsl:template name="ANDate">
		<xsl:param name="p_date"/>
		<xsl:if test="$p_date != ''">
			<xsl:variable name="v_yyyy">
				<xsl:value-of select="concat(substring($p_date, 1, 4), '-')"/>
			</xsl:variable>
			<xsl:variable name="v_mm">
				<xsl:value-of select="concat(substring($p_date, 5, 2), '-')"/>
			</xsl:variable>
			<xsl:variable name="v_dd">
				<xsl:value-of select="substring($p_date, 7, 2)"/>
			</xsl:variable>
			<xsl:value-of select="concat($v_yyyy, $v_mm, $v_dd)"/>
		</xsl:if>
	</xsl:template>
	<!-- AN DateTime Template -->
	<xsl:template name="ANDateTime">
		<xsl:param name="p_date"/>
		<xsl:param name="p_time"/>
		<xsl:param name="p_timezone"/>
		<xsl:if test="$p_date != ''">
			<xsl:variable name="v_yyyy">
				<xsl:value-of select="concat(substring($p_date, 1, 4), '-')"/>
			</xsl:variable>
			<xsl:variable name="v_mm">
				<xsl:value-of select="concat(substring($p_date, 5, 2), '-')"/>
			</xsl:variable>
			<xsl:variable name="v_dd">
				<xsl:value-of select="substring($p_date, 7, 2)"/>
			</xsl:variable>
			<xsl:variable name="v_date">
				<xsl:value-of select="concat($v_yyyy, $v_mm, $v_dd)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length($p_time) &gt; 0">
					<xsl:variable name="v_hh">
						<xsl:value-of select="concat(substring($p_time, 1, 2), ':')"/>
					</xsl:variable>
					<xsl:variable name="v_min">
						<xsl:value-of select="concat(substring($p_time, 3, 2), ':')"/>
					</xsl:variable>
					<xsl:variable name="v_ss">
						<xsl:value-of select="substring($p_time, 5, 2)"/>
					</xsl:variable>
					<xsl:variable name="v_time">
						<xsl:value-of select="concat($v_hh, $v_min, $v_ss)"/>
					</xsl:variable>
					<xsl:value-of select="concat($v_date, 'T', $v_time, $p_timezone)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="v_tim">
<!--						<xsl:value-of select="current-dateTime()"/>-->
						<xsl:value-of select="'12:00:00'"/>						
					</xsl:variable>
					<xsl:value-of
						select="concat($v_date, 'T', $v_tim, $p_timezone)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- S/4 HANA Date Template -->
	<xsl:template name="S4Date">
		<xsl:param name="p_date"/>
		<xsl:if test="$p_date != ''">
			<xsl:variable name="v_part1">
				<xsl:value-of select="substring-before($p_date,'/')"/>
			</xsl:variable>
			<xsl:variable name="v_mm">
				<xsl:value-of select="format-number($v_part1,'00')"/>
			</xsl:variable>
			<xsl:variable name="v_part2">
				<xsl:value-of select="substring-after($p_date,'/')"/>
			</xsl:variable>
			<xsl:variable name="v_part3">
				<xsl:value-of select="substring-before($v_part2, '/')"/>
			</xsl:variable>
			<xsl:variable name="v_dd">
				<xsl:value-of select="format-number($v_part3,'00')"/>
			</xsl:variable>
			<xsl:variable name="v_part4">
				<xsl:value-of select="substring-after($v_part2, '/')"/>
			</xsl:variable>
			<xsl:variable name="v_yyyy">
				<xsl:value-of select="format-number($v_part4,'00')"/>
			</xsl:variable>
			<xsl:value-of select="concat($v_yyyy, '-' ,$v_mm, '-' , $v_dd)"/>
		</xsl:if>
	</xsl:template>
	<!-- Outbound lang Template -->
	<xsl:template name="FillLangOut">
		<xsl:param name="p_spras_iso"/>
		<xsl:param name="p_spras"/>
		<xsl:param name="p_lang"/>
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($p_spras_iso)) &gt; 0">
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="$p_spras_iso"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($p_spras)) &gt; 0">
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="$p_spras"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="$p_lang"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ERP DateTime Template -->
	<xsl:template name="ERPDateTime">
		<xsl:param name="p_date"/>
		<xsl:param name="p_timezone"/>
		<xsl:if test="$p_date != ''">
			<!--Conver the AN date into SAP system zone-->
			<xsl:variable name="v_time">
				<xsl:choose>
					<!--If TimeZone contains '-' negative sign-->
					<xsl:when test="substring($p_timezone, 1, 1) = '-'">
						<xsl:value-of
							select="concat('-', 'PT', substring($p_timezone, 2, 2), 'H', substring($p_timezone, 5, 2), 'M')"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('PT', substring($p_timezone, 2, 2), 'H', substring($p_timezone, 5, 2), 'M')"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="v_erpdatetimezone">
				<xsl:value-of
					select="adjust-dateTime-to-timezone($p_date, xs:dayTimeDuration($v_time))"/>
			</xsl:variable>
			<xsl:value-of select="$v_erpdatetimezone"/>
		</xsl:if>
	</xsl:template>
	<!-- Template for CIG Add On version check-->
	<xsl:template name="Check_SupportVersion">
		<xsl:param name="p_sysversion"/>
		<xsl:param name="p_suppversion"/>
		<xsl:variable name="p_versioncheck">
			<xsl:value-of select="substring($p_sysversion, 9, 2)"/>
		</xsl:variable>		
		<xsl:if test="number($p_versioncheck) >= number($p_suppversion)">
			<xsl:value-of select="'true'"/>
		</xsl:if>		
	</xsl:template>
	<!--  User Defined Template for Inbound Proxy Comment Filling-->
	<xsl:template name="ExtractComments">
		<xsl:param name="p_comments"/>
		<xsl:param name="p_lang"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_attribute"/>
		<xsl:param name="p_linenum"/>

		<xsl:if test="$anCrossRefFlag = 'YES'">

			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!--Calling the removeChild template to exclude the attachments URL if it exists-->
			<xsl:variable name="v_comments">
				<xsl:call-template name="removeChild">
					<xsl:with-param name="p_comment" select="$p_comments"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="v_SpotQuoteID">
				<xsl:if test="$p_attribute = 'SpotQuoteID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SpotQuoteID))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SpotQuoteID"
						/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="v_HeaderTextId">
				<xsl:if test="$p_attribute = 'HeaderTextID'">
					<!--IG-23651-To retrieve only first index Workaround for XSLT error 
					in case Cross-ref params are duplicate-Only for QuoteRequest params-->
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]"
						/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="v_LineTextId">
				<!--IG-23651-To retrieve only first index Workaround for XSLT error in case Cross-ref params are duplicate-Only for QuoteRequest params-->
				<xsl:if test="$p_attribute = 'LineTextID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1]"
						/>
					</xsl:if>

				</xsl:if>
			</xsl:variable>

			<xsl:if test="$v_comments != ''">
				<xsl:call-template name="SplitComments">
					<xsl:with-param name="p_str" select="normalize-space($v_comments)"/>
					<xsl:with-param name="p_strlen" select="132.0"/>
					<xsl:with-param name="p_hdrtextid" select="$v_HeaderTextId"/>
					<xsl:with-param name="p_linetextid" select="$v_LineTextId"/>
					<xsl:with-param name="p_linenum" select="$p_linenum"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="string-length($v_SpotQuoteID) > 0">
				<item>
					<TEXT_ID>
						<xsl:value-of select="$v_SpotQuoteID"/>
					</TEXT_ID>

					<TEXT_FORM>*</TEXT_FORM>
					<TEXT_LINE>
						<xsl:value-of select="normalize-space($p_comments)"/>
					</TEXT_LINE>
				</item>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for Comment Split-->
	<xsl:template name="SplitComments">
		<xsl:param name="p_str"/>
		<xsl:param name="p_strlen"/>
		<xsl:param name="p_tdformat"/>
		<xsl:param name="p_hdrtextid"/>
		<xsl:param name="p_linetextid"/>
		<xsl:param name="p_linenum"/>

		<xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
		<xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
		<xsl:if test="$v_str1">
			<item>
				<xsl:if test="string-length($p_hdrtextid) > 0">
					<TEXT_ID>
						<xsl:value-of select="$p_hdrtextid"/>
					</TEXT_ID>
				</xsl:if>
				<xsl:if test="string-length($p_linetextid) > 0">
					<TEXT_ID>
						<xsl:value-of select="$p_linetextid"/>
					</TEXT_ID>
				</xsl:if>
				<xsl:if test="string-length($p_linenum) > 0">
					<PO_ITEM>
						<xsl:value-of select="$p_linenum"/>
					</PO_ITEM>
				</xsl:if>

				<TEXT_FORM>*</TEXT_FORM>
				<TEXT_LINE>
					<xsl:value-of select="$v_str1"/>
				</TEXT_LINE>
			</item>
		</xsl:if>
		<xsl:if test="$v_str2">
			<xsl:call-template name="SplitComments">
				<xsl:with-param name="p_str" select="$v_str2"/>
				<xsl:with-param name="p_strlen" select="$p_strlen"/>
				<xsl:with-param name="p_hdrtextid" select="$p_hdrtextid"/>
				<xsl:with-param name="p_linetextid" select="$p_linetextid"/>
				<xsl:with-param name="p_linenum" select="$p_linenum"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for Inbound Proxy Comment Filling-->
	<xsl:template name="CommentsFillProxyIn">
		<xsl:param name="p_comments"/>
		<xsl:param name="p_lang"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_shipcontrolid"/>
		<!--Calling the removeChild template to exclude the attachments URL if it exists-->
		<xsl:variable name="v_comments">
			<xsl:call-template name="removeChild">
				<xsl:with-param name="p_comment" select="$p_comments"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$v_comments != '' and $anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read TextId from PD -->
			<xsl:variable name="v_textid">
				<xsl:choose>

					<xsl:when test="$p_itemNumber != ''">
						<!--IG-23651-To retrieve only first index Workaround for XSLT error 
						in case Cross-ref params are duplicate-Only for QuoteRequest params-->
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1])"
						/>
					</xsl:when>
					<xsl:when test="$p_shipcontrolid = 'ShipControlTextID'">
						<xsl:if
							test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ShipControlTextID))">
							<xsl:value-of
								select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ShipControlTextID"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1])"
						/>
					</xsl:otherwise>

				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$v_textid != ''">
				<!--         <AribaComment>-->
				<Item>
					<TextID>
						<xsl:value-of select="$v_textid"/>
					</TextID>
					<TextLang>
						<xsl:value-of select="$p_lang"/>
					</TextLang>
					<xsl:if test="$p_itemNumber != ''">
						<ItemNumber>
							<xsl:value-of select="$p_itemNumber"/>
						</ItemNumber>
					</xsl:if>
					<xsl:call-template name="CommentSplitProxy">
						<!-- Begin of IG-28081 -->
						<!-- Below Line is commented, as normalize-space is removing the formatting especially Line feeds
						    and normalize-space is removed while passing the comments-->
						<xsl:with-param name="p_str" select="$v_comments"/>
						<!-- End   of IG-28081 -->
						<xsl:with-param name="p_strlen" select="132.0"/>
					</xsl:call-template>
				</Item>
				<!--</AribaComment>-->
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for Comment Split-->
	<xsl:template name="CommentSplitProxy">
		<xsl:param name="p_str"/>
		<xsl:param name="p_strlen"/>
		<xsl:param name="p_tdformat"/>
		<xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
		<xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
		<xsl:if test="$v_str1">
			<AribaLine>
				<TextLine>
					<xsl:value-of select="$v_str1"/>
				</TextLine>
			</AribaLine>
		</xsl:if>
		<xsl:if test="$v_str2">
			<xsl:call-template name="CommentSplitProxy">
				<xsl:with-param name="p_str" select="$v_str2"/>
				<xsl:with-param name="p_strlen" select="$p_strlen"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for IDOC Comment Filling-->
	<xsl:template name="CommentsFillIdocIn">
		<xsl:param name="p_comments"/>
		<xsl:param name="p_lang"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<!--Calling the removeChild template to exclude the attachments URL if it exists-->
		<xsl:variable name="v_comments">
			<xsl:call-template name="removeChild">
				<xsl:with-param name="p_comment" select="$p_comments"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$v_comments != '' and $anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read TextId from PD -->
			<xsl:variable name="v_textid">
				<xsl:choose>
					<xsl:when test="$p_itemNumber != ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1])"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1])"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$v_textid != ''">
				<!--<ARBCIG_COMMENT SE GMENT="1">-->
				<TDID>
					<xsl:value-of select="$v_textid"/>
				</TDID>
				<TDSPRAS>
					<xsl:value-of select="$p_lang"/>
				</TDSPRAS>
				<TDSPRAS_ISO>
					<xsl:value-of select="$p_lang"/>
				</TDSPRAS_ISO>				
				<xsl:if test="$p_itemNumber != ''">
					<ITEMNUMBER>
						<xsl:value-of select="$p_itemNumber"/>
					</ITEMNUMBER>
				</xsl:if>
				<xsl:call-template name="CommentSplitIdoc">
					<!-- Begin of IG-28081 -->
					<!-- Below Line is commented, as normalize-space is removing the formatting especially Line feeds
						    and normalize-space is removed while passing the comments-->
					<xsl:with-param name="p_str" select="$v_comments"/>
					<!-- End of IG-28081 -->
					<xsl:with-param name="p_strlen" select="132.0"/>
				</xsl:call-template>
				<!--</ARBCIG_COMMENT>-->
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for IDOC Comment Split-->
	<xsl:template name="CommentSplitIdoc">
		<xsl:param name="p_str"/>
		<xsl:param name="p_strlen"/>
		<xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
		<xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
<!--		IG-29477 populate e1arbcig_lines only if sting is having any value to be populated for tdline-->
		<xsl:if test="string-length(normalize-space($v_str1)) > 0">			
			<E1ARBCIG_LINES SEGMENT="1">
				<TDLINE>
					<xsl:value-of select="$v_str1"/>
				</TDLINE>
			</E1ARBCIG_LINES>
		</xsl:if>
		<xsl:if test="string-length(normalize-space($v_str2)) > 0">	
			<xsl:call-template name="CommentSplitIdoc">
				<xsl:with-param name="p_str" select="$v_str2"/>
				<xsl:with-param name="p_strlen" select="$p_strlen"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--  Standard Template for PO IDOC Outbound Comment Fill-->
	<xsl:template name="CommentsFillIdocOutPO">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:variable name="v_textID">
				<xsl:choose>
					<xsl:when test="$p_doctype = 'QuoteRequest'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1])"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1])"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDPO)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDPO)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:variable>
			<!--			Logic for accomodating Multiple Comments-->
			<!--			Logic explained here applies for templates CommentsFillIdocOutPO, CommentsFillIdocOut and CommentsFillProxyOut-->
			<!--			Making use of contains(str1,str2) func to achieve this , true is returned when str2 is present as a subset in str1.-->
			<!--			Here , $v_textID is CIG Crossref and TDID is payload text id.-->
			<xsl:if test="$p_aribaComment/TDID and $p_itemNumber = '' and $v_textID != ''">
				<!--		    Above If Condition is simplified and one to one TextID check is removed since we need to consider all entries ,
		                    they are later filtered via for-each statements.-->
				<xsl:attribute name="xml:lang">
					<xsl:for-each
						select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]/TSSPRAS_ISO">
						<!--			To Read ISO Code only once , called in loop with position 1. Otherwise value-of select will execute once for each instance of condition met -->
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				<xsl:for-each
					select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]">
	
					<xsl:variable name="v_desc">
						<xsl:if test="string-length(E1ARBCIG_DESC/TDDESC) > 0">
						<xsl:value-of select="concat(' ',E1ARBCIG_DESC/TDDESC, ':')"/>
						</xsl:if>
					</xsl:variable>
					<xsl:for-each select="E1EDKT2/TDLINE">
					<xsl:if test="../../TDID">
						<xsl:choose>
							<!--			This is to add space inbetween two comments. Just select first time and select space with next comment for subsequent iterations.-->
							<xsl:when test="position() = 1">
								
								<xsl:choose>
									<xsl:when test="string-length($v_desc) > 0">	
										<xsl:value-of select="concat($v_desc, .)"/>										
									</xsl:when>
									<xsl:otherwise>
<!--									<xsl:value-of select="."/>	-->
										<xsl:value-of select="concat(' ', .)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
																<xsl:value-of select="concat(' ', .)"/>
<!--								<xsl:value-of select="concat(' ', $v_desc, .)"/>-->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="$p_aribaComment = E1EDPT1">
				<xsl:if test="$p_itemNumber != '' and $v_textID != ''">
					<xsl:attribute name="xml:lang">
						<xsl:for-each
							select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]/TSSPRAS_ISO">
							<xsl:if test="position() = 1">
								<xsl:value-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
					<xsl:for-each
						select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]">
						<xsl:variable name="v_desc">
							<xsl:if test="string-length(E1ARBCIG_DESC_ITEM/TDDESC) > 0">							
							<xsl:value-of select="concat(' ',E1ARBCIG_DESC_ITEM/TDDESC, ':')"/>
							</xsl:if>
						</xsl:variable>
						<xsl:for-each select="E1EDPT2/TDLINE">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length($v_desc) > 0">	
										<xsl:value-of select="concat($v_desc, .)"/>										
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(' ', .)"/>
<!--									<xsl:value-of select="."/>										-->
									</xsl:otherwise>
								</xsl:choose>								
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(' ', .)"/>
<!--								<xsl:value-of select="concat(' ', $v_desc, .)"/>-->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$p_aribaComment = E1EDCT1">
				<xsl:if test="$p_itemNumber != '' and $v_textID != ''">
					<xsl:attribute name="xml:lang">
						<xsl:for-each
							select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]/TSSPRAS_ISO">
							<xsl:if test="position() = 1">
								<xsl:value-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:attribute>
					<xsl:for-each
						select="$p_aribaComment[contains($v_textID, normalize-space(TDID))]">

						<xsl:variable name="v_desc">
							<xsl:value-of select="concat('',E1ARBCIG_DESC_SITEM, ':')"/>
						</xsl:variable>
						<xsl:for-each select="E1EDCT2/TDLINE">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length($v_desc) > 1">	
										<xsl:value-of select="concat($v_desc, .)"/>										
									</xsl:when>
									<xsl:otherwise>
									<xsl:value-of select="."/>										
									</xsl:otherwise>
								</xsl:choose>
								

							</xsl:when>
							<xsl:otherwise>
																<xsl:value-of select="concat(' ', .)"/>
<!--								<xsl:value-of select="concat(' ', $v_desc, .)"/>-->
							</xsl:otherwise>
						</xsl:choose>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--  User Defined Template for IDOC Outbound Comment Fill-->
	<xsl:template name="CommentsFillIdocOut">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_trans"/>
		<xsl:param name="p_attach"/>

		<xsl:if test="$p_aribaComment != '' and $anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:variable name="v_textID">
				<xsl:choose>
					<!--This is for MM Invoice Transaction	-->
					<xsl:when test="$p_trans = 'MMInvoice'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDMM)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDMM)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!--This is for PaymentRemittance Request Transaction	-->
					<xsl:when test="$p_trans = 'PaymentRemittance'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDPR)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDPR)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1])"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1])"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Filter the HeaderTextID from PD values -->
			<!-- Filter the HeaderTextID from PD values -->
			<xsl:if test="$p_itemNumber = '' and $v_textID != ''">
				<xsl:choose>
					<xsl:when test="$p_trans = 'PaymentRemittance'">
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="$p_aribaComment[not(ItemNumber) and TextID = $v_textID]/TextLang"/>
							<xsl:for-each
								select="$p_aribaComment[not(ITEMNUMBER) and contains($v_textID, normalize-space(TDID))]/TDSPRAS">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$p_trans = 'MMInvoice'">
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="$p_aribaComment[not(ItemNumber) and TextID = $v_textID]/TextLang"/>
							<xsl:for-each
								select="$p_aribaComment[not(ITEMNUMBER) and contains($v_textID, normalize-space(TDID))]/TDSPRAS_ISO">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				<xsl:for-each
					select="$p_aribaComment[not(ITEMNUMBER) and contains($v_textID, normalize-space(TDID))]">
					<xsl:for-each select="E1ARBCIG_LINES/TDLINE">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length(../../TDDESC) > 0">	
										<xsl:value-of select="concat(' ', ../../TDDESC, ':', .)"/>										
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(' ', .)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
			<!-- Filter the LineTextID from PD values -->
			<xsl:if
				test="$p_aribaComment[ITEMNUMBER = $p_itemNumber] and $p_itemNumber != '' and $v_textID != ''">
				<xsl:attribute name="xml:lang">
					<xsl:for-each
						select="$p_aribaComment[ITEMNUMBER = $p_itemNumber and contains($v_textID, normalize-space(TDID))]/TDSPRAS_ISO">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				<xsl:for-each
					select="$p_aribaComment[ITEMNUMBER = $p_itemNumber and contains($v_textID, normalize-space(TDID))]">
					<xsl:for-each select="E1ARBCIG_LINES/TDLINE">
						<xsl:variable name="v_desc">
							<xsl:value-of select="concat(normalize-space(../../TDDESC), ':')"/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length(../../TDDESC) > 0">	
										<xsl:value-of select="concat(' ', ../../TDDESC, ':', .)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(' ', .)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CommentsFillProxyOut">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_trans"/>
	    <!--	Begin of IG-19747	-->    
            <!--	    <xsl:template name="CommentsFillProxyOut">-->
	        <!-- Map multiple comments to cXML  -->
	        <!-- Takes all the comments and create as many <Comments>  -->
            <!--	         input      p_aribaComment	       : Comments as provided       -->
            <!--			            p_itemNumber             : Line Number                -->
            <!--			            p_doctype                : Target Document Type       -->
            <!--			            p_pd                     : Cross Reference Parameter  -->
            <!--			            p_tran  s                : Transaction name           -->
             <!--           output                    	       : cXML message with <Comments> and Attribute xml:lang along with language			-->
         <!--	End of IG-19747    -->
		<xsl:if test="$p_aribaComment != '' and $anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read TextId from PD -->
			<xsl:variable name="v_textID">
				<xsl:choose>
					<!--This is for Dispatch Delivery notification Transaction	-->
					<xsl:when test="$p_trans = 'DDN'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDDDN)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDDDN)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!--This is for Invoice Status Update Transaction	-->
					<xsl:when test="$p_trans = 'ISU'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDISU)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDISU)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1])"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1])"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		    <!--		Begin of IG-19747 Changes	-->
		    <!--Get the Default Language -\\->-->
		    <xsl:variable name="v_lang">
		        <xsl:call-template name="FillDefaultLang">
		            <xsl:with-param name="p_doctype" select="$p_doctype"/>
		            <xsl:with-param name="p_pd" select="$p_pd"/>
		        </xsl:call-template>
		    </xsl:variable>			
		    <!--		End of IG-19747 Changes	-->
			<!-- Filter the HeaderTextID from PD values -->
			<xsl:if
				test="$p_aribaComment/Item[not(ItemNumber)] and $p_itemNumber = '' and $v_textID != ''">
			    <!--	Begin of IG-19747	-->
			    <xsl:variable name="v_lan">
			        <xsl:value-of select="$p_aribaComment/Item/TextLang"/>
			    </xsl:variable>	
			    <xsl:choose>
			        <xsl:when test="$v_lan = ''">
			            <xsl:attribute name="xml:lang">
			                <xsl:for-each
			                    select="$p_aribaComment/Item and contains($v_textID, normalize-space(TextID))">
			                    <xsl:if test="position() = 1">
			                        <xsl:choose>
			                            <xsl:when test="$v_lang !=''">
			                                <xsl:value-of select="$v_lang"/>
			                            </xsl:when>
			                            <xsl:otherwise>
			                                <xsl:value-of select="'en'"/>
			                            </xsl:otherwise>
			                        </xsl:choose>
			                    </xsl:if>	
			                </xsl:for-each>	
			            </xsl:attribute>		
			        </xsl:when>
			        <xsl:otherwise>
			      <!--	End of Changes IG-19747		-->
				<xsl:attribute name="xml:lang">
					<xsl:for-each
						select="$p_aribaComment/Item[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]/TextLang">
						<xsl:if test="position() = 1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
			    <!--     Begin of IG-19747  -->
			        </xsl:otherwise>	
			    </xsl:choose>	
			    <!-- 	End of IG-19747	-->	      
				<xsl:for-each
					select="$p_aribaComment/Item[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]">
					<xsl:variable name="v_desc">
						<xsl:value-of select="concat(TextDesc, ':')"/>
					</xsl:variable>
					<xsl:for-each select="AribaLine/TextLine">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length($v_desc) > 1">	
										<xsl:value-of select="concat(' ', $v_desc, .)"/>										
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(' ', .)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(' ', .)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
			<!-- Filter the LineTextID from PD values -->
			<xsl:if
				test="$p_aribaComment/Item[ItemNumber = $p_itemNumber] and $p_itemNumber != '' and $v_textID != ''">
			    <!--	Begin of IG-19747	-->
			    <xsl:variable name="v_language">
			        <xsl:for-each
			            select="$p_aribaComment/Item[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]/TextLang">
			            <xsl:if test="position() = 1">
			                <xsl:value-of select="."/>
			            </xsl:if>
			        </xsl:for-each>
			    </xsl:variable>
			    <xsl:attribute name="xml:lang">
			        <xsl:choose>
			            <xsl:when test="string-length($v_language) > 0">
			                <xsl:value-of select="$v_language"/>
			            </xsl:when>
			            <xsl:when test="string-length($v_lang) > 0">
			                <xsl:value-of select="$v_lang"/>
			            </xsl:when>
			            <xsl:otherwise>
			                <xsl:value-of select="'en'"/>
			            </xsl:otherwise>
			        </xsl:choose>
			    </xsl:attribute>
			    <!--	End of IG-19747	-->
				<xsl:for-each
					select="$p_aribaComment/Item[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]">
					<xsl:variable name="v_desc">
						<xsl:value-of select="concat(TextDesc, ':')"/>
					</xsl:variable>
					<xsl:for-each select="AribaLine/TextLine">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:choose>
									<xsl:when test="string-length($v_desc) > 1">	
										<xsl:value-of select="concat(' ', $v_desc, .)"/>										
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="(.)"/>	
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(' ', .)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--Variable to identify the systemID-->
	<xsl:template name="MultiErpSysIdIN">
		<xsl:param name="p_ansysid"/>
		<xsl:param name="p_erpsysid"/>
		<xsl:choose>
			<xsl:when test="$p_erpsysid != ''">
				<xsl:value-of select="$p_erpsysid"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$p_ansysid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Fill the PORT information from CrossRef-->
	<xsl:template name="FillPort">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Port from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/PortName)"
			/>
		</xsl:if>
	</xsl:template>
	<!--Prepare the CrossRef path-->
	<xsl:template name="PrepareCrossref">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_erpsysid"/>
		<xsl:param name="p_ansupplierid"/>
		<!--constructing the crossreference string-->
		<xsl:variable name="v_crossref">
			<!--<xsl:value-of select="concat('CROSSREFERENCE', '_', $p_erpsysid, '_', $p_doctype)"/>-->
			<!-- CROSSREFERENCE_SYSTEMID_DOCTYPE file name changed to CROSSREFERENCE_SYSTEMID for September Release-->
			<xsl:value-of select="concat('CROSSREFERENCE', '_', $p_erpsysid)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$anLocalTesting ='YES'">
				<xsl:value-of
					select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/ParameterCrossReference.xml'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('pd', ':', $p_ansupplierid, ':', $v_crossref, ':', 'Binary')"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	<!--    Get the Default Language -->
	<xsl:template name="FillDefaultLang">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default Language from PD -->
			<xsl:choose>
				<xsl:when test="normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DefaultLang)!=''">
					<xsl:value-of
						select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DefaultLang)"
					/>					
				</xsl:when>
				<xsl:otherwise>en</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--    Get the IsLogicalSystemEnabled infor -->
	<xsl:template name="LogicalSystemEnabled">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default Language from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LSEnabled)"
			/>
		</xsl:if>
	</xsl:template>
	<!--	 IG-41238 start-->
	<!--    Get the BuyingandInvoicingEnabled infor -->
	<xsl:template name="BuyingandInvoicingEnabled">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read B&I enabled from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/BuyingandInvoicingEnabled)"
			/>
		</xsl:if>
	</xsl:template>
	<!--	 IG-41238 end-->
	<!--Inbound attachment for IDOC -->
	<xsl:template name="InboundAttachIDOC">
		<!-- InboundAttachIDOC  -->
		<!-- Takes all the attachment details from the cXML and create the attachment segment in the IDOC.  -->
		<!-- input  lineReference    : Line Level Content ID from the cXML message under <Attachment><URL>
			                         : along with Line Number for Line Level Attachment.If lineReference has 
			                         : no value, then the attachment is for header. The Attachment content 
			                         : will be split after 1000 characters. 
			                          
             output              	 : IDOC attachment segment <E1ARBCIG_ATTACH_HDR_DET> 
             _____________________________________________________________________________________________
		     template used by        : MAPPING_ANY_cXML_0000_PayMeNowRequest_AddOn_0000_PayMeNow.xsl        -->
		<xsl:param name="lineReference"/>
		<xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
		<xsl:for-each select="$eachAtt">
			<xsl:variable name="count" select="position()"/>
			<E1ARBCIG_ATTACH_HDR_DET>
				<xsl:attribute name="SEGMENT">1</xsl:attribute>
				<FILENAME>
					<xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
				</FILENAME>
				<CONTENTTYPE>
					<xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
				</CONTENTTYPE>
				<CONTENTID>
					<xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
				</CONTENTID>
				<LINENUMBER>
					<xsl:call-template name="getAttLineNo">
						<xsl:with-param name="line" select="$lineReference"/>
						<xsl:with-param name="contentID" select="$eachAtt[$count]/AttachmentID"/>
					</xsl:call-template>
				</LINENUMBER>
				<xsl:call-template name="splitAttContent">
					<xsl:with-param name="content" select="$eachAtt[$count]/AttachmentContent"/>
				</xsl:call-template>
			</E1ARBCIG_ATTACH_HDR_DET>
		</xsl:for-each>
	</xsl:template>
	<!--Inbound attachment for Proxy -->
	<xsl:template name="InboundAttach">
		<!-- InboundAttach  -->
		<!-- Takes all the attachment details from the cXML and create the attachment segment in the proxy.  -->
		<!-- input lineReference     : Line Level Content ID from the cXML message under <Attachment><URL>
			                         : along with Line Number for line level attachment. 
             output              	 : proxy attachment segment <Attachment>
             ______________________________________________________________________________________________
             template called by      : MAPPING_ANY_cXML_0000_ComponentConsumptionRequest_AddOn_0000_ComponentConsumptionRequest.xsl
                                       MAPPING_ANY_cXML_0000_FIInvoiceDetailRequest_AddOn_0000_FIInvoice.xsl
                                       MAPPING_ANY_cXML_0000_LiabilityRequest_AddOn_0000_LiabilityTransfer.xsl
                                       MAPPING_ANY_cXML_0000_OrderConfirmationApprovalRequest_AddOn_0000_OrderConfirmationApprovalRequest.xsl
                                       MAPPING_ANY_cXML_0000_PaymentRemittance_AddOn_0000_RemittanceAdvice.xsl
                                       MAPPING_ANY_cXML_0000_ProductReplenishmentMessage_AddOn_0000_ProductReplenishmentMessage.xsl
                                       MAPPING_ANY_cXML_0000_QualityNotificationRequest_AddOn_0000_QualityIssueNotificationMessage.xsl
                                       MAPPING_ANY_cXML_0000_ReceiptRequest_AddOn_0000_ComponentAcknowledgement.xsl
                                       MAPPING_ANY_cXML_0000_ServiceEntrySheet_AddOn_0000_ServiceSheet.xsl
		-->
		<xsl:param name="lineReference"/>
		<xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
		<xsl:if test="$eachAtt">
			<Attachment>
				<xsl:for-each select="$eachAtt">
					<xsl:variable name="count" select="position()"/>
					<Item>
						<FileName>
							<xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
						</FileName>
						<ContentType>
							<xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
						</ContentType>
						<ContentId>
							<xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
						</ContentId>
						<LineNumber>
							<xsl:call-template name="getAttLineNo">
								<xsl:with-param name="line" select="$lineReference"/>
								<xsl:with-param name="contentID"
									select="$eachAtt[$count]/AttachmentID"/>
							</xsl:call-template>
						</LineNumber>
						<Content>
							<xsl:value-of select="$eachAtt[$count]/AttachmentContent"/>
						</Content>
					</Item>
				</xsl:for-each>
			</Attachment>
		</xsl:if>
	</xsl:template>
	<!--New Inbound attachment for Souring Proxy where few proxy structures are generated with 'Attachments' node-->
	<xsl:template name="InboundAttachs">
		<!-- InboundAttachs  -->
		<!-- Takes all the attachment details from the cXML and create the attachment segment in the proxy.  -->
		<!-- input  lineReference    : Line Level Content ID from the cXML message under <Attachment><URL>
			                         : along with Line Number.
			                         : 
             output              	 : proxy attachment segment <Attachments>
             _____________________________________________________________________________________________
             template used by        : MAPPING_ANY_cXML_0000_ContractRequest_AddOn_0000_ContractRequest.xsl
                                       MAPPING_ANY_cXML_0000_PaymentReceiptConfirmationRequest_AddOn_0000_PaymentReceiptConfirmationRequest.xsl
                                       MAPPING_ANY_cXML_0000_QualityInspectionResultRequest_AddOn_0000_QualityInspectionResultRequest.xsl
                                       MAPPING_ANY_cXML_0000_QuoteMessageContract_AddOn_0000_QuoteMessageContract.xsl
                                       MAPPING_ANY_cXML_0000_SalesOrderRequest_AddOn_0000_ReplenishmentOrderRequest.xsl
		-->
		<xsl:param name="lineReference"/>
		<xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
		<xsl:if test="$eachAtt">
			<Attachments>
				<xsl:for-each select="$eachAtt">
					<xsl:variable name="count" select="position()"/>
					<Item>
						<FileName>
							<xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
						</FileName>
						<ContentType>
							<xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
						</ContentType>
						<ContentId>
							<xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
						</ContentId>
						<LineNumber>
							<xsl:call-template name="getAttLineNo">
								<xsl:with-param name="line" select="$lineReference"/>
								<xsl:with-param name="contentID"
									select="$eachAtt[$count]/AttachmentID"/>
							</xsl:call-template>
						</LineNumber>
						<Content>
							<xsl:value-of select="$eachAtt[$count]/AttachmentContent"/>
						</Content>
					</Item>
				</xsl:for-each>
			</Attachments>
		</xsl:if>
	</xsl:template>

	<xsl:template name="InboundAttachsn0">
		<!-- InboundAttachn0  -->
		<!-- Takes all the attachment details from the cXML and create the attachment segment in the proxy.  -->
		<!-- input  lineReference    : Line Level Content ID from the cXML message under <Attachment><URL>
			                         : along with Line Number. This is used by ARBCI2 - EHP4 interfaces  
             output              	 : proxy attachment segment <n0:Attachments> with a namespace n0 
             ___________________________________________________________________________________________________
		     template used by        : MAPPING_ANY_cXML_0000_ContractRequestServices_AddOn_0000_ContractRequestServices.xsl
		                               MAPPING_ANY_cXML_0000_QuoteMessageContractServices_AddOn_0000_PurchasingContractERPRequest.xsl
		                               MAPPING_ANY_cXML_0000_QuoteMessageSchedulingAgreement_AddOn_0000_QuoteMessageSchedulingAgreement.xsl
		                               MAPPING_ANY_cXML_0000_SchedulingAgreement_AddOn_0000_SchedulingAgreement.xsl

		-->
		<xsl:param name="lineReference"/>
		<xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
		<xsl:if test="$eachAtt">
			<n0:Attachments xmlns:n0="http://sap.com/xi/ARBCIG2">
				<xsl:for-each select="$eachAtt">
					<xsl:variable name="count" select="position()"/>
					<Item>
						<FileName>
							<xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
						</FileName>
						<ContentType>
							<xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
						</ContentType>
						<ContentId>
							<xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
						</ContentId>
						<LineNumber>
							<xsl:call-template name="getAttLineNo">
								<xsl:with-param name="line" select="$lineReference"/>
								<xsl:with-param name="contentID"
									select="$eachAtt[$count]/AttachmentID"/>
							</xsl:call-template>
						</LineNumber>
						<Content>
							<xsl:value-of select="$eachAtt[$count]/AttachmentContent"/>
						</Content>
					</Item>
				</xsl:for-each>
			</n0:Attachments>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getAttLineNo">
		<!-- getAttLineNo  -->
		<!-- Takes all the attachment details of the line level from the cXML and gets the line number of.  -->
		<!-- each attachment. The line numbers and line attachments are sent together in contentID variable.-->		
		<!-- input  line	         : Line Number from cXML
			        contentID        : Line Level Content ID from the cXML message under <Attachment><URL>
			                         : along with Line Number  
             output              	 : Line Number of each attachment -->
		<xsl:param name="line"/>
		<xsl:param name="contentID"/>
		<xsl:variable name="cid" select="concat('cid:', normalize-space($contentID))"/>
		<xsl:for-each select="$line">
			<xsl:variable name="ind" select="position()"/>
			<xsl:if test=". = $cid">
				<!-- Get the previous value -->
				<xsl:value-of select="$line[$ind - 1]"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="splitAttContent">
		<xsl:param name="content"/>
		<xsl:variable name="line-length" select="1000"/>
		<xsl:variable name="line" select="substring($content, 1, $line-length)"/>
		<xsl:variable name="rest" select="substring($content, $line-length + 1)"/>
		<xsl:if test="$line">
			<E1ARBCIG_ATTACH_CONTENT_DET>
				<xsl:attribute name="SEGMENT">1</xsl:attribute>
				<CONTENT>
					<xsl:value-of select="$line"/>
				</CONTENT>
			</E1ARBCIG_ATTACH_CONTENT_DET>
		</xsl:if>
		<xsl:if test="$rest">
			<xsl:call-template name="splitAttContent">
				<xsl:with-param name="content" select="$rest"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--Outbound attachment for Proxy -->
	<xsl:template name="OutBoundAttach">
		<xsl:variable name="eachAtt" select="Attachments/Item | Attachment/Item"/>
		<xsl:if test="$eachAtt">
			<AttachmentList>
				<xsl:for-each select="$eachAtt">
					<Attachment>
						<xsl:variable name="count" select="position()"/>
						<AttachmentType>
							<xsl:value-of select="$eachAtt[$count]/ContentType"/>
						</AttachmentType>
						<AttachmentName>
							<xsl:value-of select="$eachAtt[$count]/FileName"/>
						</AttachmentName>
						<AttachmentID>
							<xsl:value-of select="normalize-space($eachAtt[$count]/ContentId)"/>
						</AttachmentID>
						<AttachmentContent>
							<xsl:value-of select="$eachAtt[$count]/Content"/>
						</AttachmentContent>
					</Attachment>
				</xsl:for-each>
			</AttachmentList>
		</xsl:if>
	</xsl:template>
	<!--Outbound attachment for IDOC -->
	<xsl:template name="OutBoundAttachIDOC">
		<xsl:param name="eachAtt"/>
		<xsl:if test="$eachAtt">
			<AttachmentList>
				<xsl:for-each select="$eachAtt">
					<xsl:variable name="count" select="position()"/>
					<Attachment>
						<AttachmentName>
							<xsl:value-of select="$eachAtt[$count]/FILENAME"/>
						</AttachmentName>
						<AttachmentType>
							<xsl:value-of select="$eachAtt[$count]/CONTENTTYPE"/>
						</AttachmentType>
						<AttachmentID>
							<xsl:value-of select="normalize-space($eachAtt[$count]/CONTENTID)"/>
						</AttachmentID>
						<xsl:variable name="mergedContent">
							<xsl:call-template name="join">
								<xsl:with-param name="list" select="E1ARBCIG_ATTACH_CONTENT_DET"/>
							</xsl:call-template>
						</xsl:variable>
						<AttachmentContent>
							<xsl:value-of select="$mergedContent"/>
						</AttachmentContent>
					</Attachment>
				</xsl:for-each>
			</AttachmentList>
		</xsl:if>
	</xsl:template>
	<xsl:template name="join">
		<xsl:param name="list"/>
		<xsl:for-each select="$list">
			<xsl:value-of select="CONTENT"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="addContenIdIDOC">
		<!-- addContenIdIDOC  -->
		<!-- Takes all the content ID for the attachment from the IDOC and adds it to the -->
		<!-- <URL> segment under <Comments><Attachment> segment of the cXML.              -->		
		<!-- input  eachAtt	         : All the attachment details under <E1ARBCIG_ATTACH_HDR_DET> segment
			        lineNumber       : Line number for line level attachments from E1ARBCIG_ATTACH_HDR_DET/LINENUMBER
             output              	 : cXML message with <Attachment><URL>
             ____________________________________________________________________________________
             template used by        : MapMultiple_Text_Comments_IDOC_To_cXML 
                                     : 
                                     : MAPPING_ANY_AddOn_0000_EnquiryOrder_cXML_0000_OrderStatusRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_Order_cXML_0000_OrderRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_PaymentRemittanceRequest_cXML_0000_PaymentRemittance.xsl
                                     : MAPPING_ANY_AddOn_0000_QuoteRequest_cXML_0000_QuoteRequest.xsl		-->
		<xsl:param name="eachAtt"/>
		<xsl:param name="lineNumber"/>
		<xsl:choose>
			<xsl:when test="$lineNumber">
				<!-- Line Level Attachments  -->
				<xsl:for-each select="$eachAtt[ number(LINENUMBER) =  number($lineNumber)]">
					<Attachment>
						<URL>
							<xsl:value-of select="concat('cid:', normalize-space(CONTENTID))"/>
						</URL>
					</Attachment>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Header Level Attachments  -->
				<xsl:for-each select="$eachAtt[string-length(LINENUMBER) = 0]">
					<Attachment>
						<URL>
							<xsl:value-of select="concat('cid:', normalize-space(CONTENTID))"/>
						</URL>
					</Attachment>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addContenId">
		<!-- addContenId  -->
		<!-- Takes all the content ID for the attachment from the proxy structures and adds -->
		<!-- it to the <URL> segment under <Comments><Attachment> segment of the cXML.      -->		
		<!-- input  eachAtt	         : All the attachment details under <Attachments> segment
			        lineNumber       : Line number for line level attachments from Attachments/LineNumber
             output              	 : cXML message with <Attachment><URL>
             __________________________________________________________________________________
             template used by        : MAPPING_ANY_AddOn_0000_PurchaseRequisition_cXML_0000_PurchaseRequisitionRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_QualityInspectionRequest_cXML_0000_QualityInspectionRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_QualityIssueNotificationMessage_cXML_0000_QualityNotificationRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_SalesOrderConfirmation_cXML_0000_ConfirmationRequest.xsl
                                     : MAPPING_ANY_AddOn_0000_ShipNoticeRequest_cXML_0000_ShipNoticeRequest.xsl	-->
		<xsl:param name="eachAtt"/>
		<xsl:param name="lineNumber"/>
		<xsl:choose>
			<xsl:when test="$lineNumber">
				<!-- Line Level Attachments  -->
				<xsl:for-each select="$eachAtt[LineNumber = $lineNumber]">
					<Attachment>
						<URL>
							<xsl:value-of select="concat('cid:', normalize-space(ContentId))"/>
						</URL>
					</Attachment>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Header Level Attachments  -->
				<xsl:for-each select="$eachAtt[string-length(LineNumber) = 0]">
					<Attachment>
						<URL>
							<xsl:value-of select="concat('cid:', normalize-space(ContentId))"/>
						</URL>
					</Attachment>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="removeChild">
		<xsl:param name="p_comment"/>
		<xsl:value-of select="$p_comment/text()"/>
	</xsl:template>
	<!-- Region Code Description Type-->
	<xsl:template name="GetRegionDesc">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/GetRegionCodeDescription)"
			/>
		</xsl:if>
	</xsl:template>

	<!-- Strategic Sourcing Dummy Vendor-->
	<xsl:template name="StrategicSourcingDummyVendor">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DummyVendor[1])"
			/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ReadQuote">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_attribute"/>
		<xsl:if test="$p_doctype != '' and $p_pd != '' and $anCrossRefFlag = 'YES'">
			<!--calling the binary PD -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:choose>
				<xsl:when test="$p_attribute = 'AccountAssignmentCat'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AccountAssignmentCategory))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AccountAssignmentCategory"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'Asset'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Asset))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Asset"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'GrossPrice'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/GrossPrice))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/GrossPrice"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ServiceGrossPrice'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/TotalPrice))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/TotalPrice"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'CostCenter'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/CostCenter))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/CostCenter"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'GLAccount'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/GLAccount))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/GLAccount"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SubNumber'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AssetSubNumber))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AssetSubNumber"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'WBSElement'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/WBSElement))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/WBSElement"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'Order'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Order))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Order"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SpotQuoteID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'HeaderTextID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID[1]"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'LineTextID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID[1]"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ItemCatService'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatService))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatService"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ItemCatStandard'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatStandard))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatStandard"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ItemCatMaterial'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatStandard))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemCatStandard"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'DeductionPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentage))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentage"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'DeductionAmount'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbs))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbs"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'AdditionalPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargePercentage))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargePercentage"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'AdditionalMoney'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargeAbs))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargeAbs"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'AdditionalAmount'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargeAbs))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SurchargeAbs"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SDeductionPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentageItem))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentageItem"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SDeductionAmount'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbsItem))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbsItem"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SAdditionalPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargePercentageItem))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargePercentageItem"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'SAdditionalMoney'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargeAbsItem))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargeAbsItem"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ODeductionPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentageHeader))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountPercentageHeader"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ODeductionAmount'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbsHeader))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DiscountAbsHeader"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'OAdditionalPercent'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargePercentageHeader))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargePercentageHeader"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'OAdditionalMoney'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargeAbsHeader))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AdditionalChargeAbsHeader"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'grosspriceTypecode'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/grosspriceTypecode))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/grosspriceTypecode"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'servicegrosspriceTypecode'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/servicegrosspriceTypecode))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/servicegrosspriceTypecode"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'HeaderTextTypecode'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextTypecode))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextTypecode"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ItemTextTypecode'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemTextTypecode))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ItemTextTypecode"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ValueContract'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ValueContract))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ValueContract"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'QuantityContract'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/QuantityContract))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/QuantityContract"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'value'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Value))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Value"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'quantity'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Quantity))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Quantity"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'DefaultPlant'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Plant))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Plant"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'OneTimeVendor'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Vendor))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/Vendor"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'DocType'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'ExternalServiceLineNote'">
					<!--IG-23651-To retrieve only first index Workaround for XSLT error in case Cross-ref params are duplicate-Only for QuoteRequest params-->
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ExternalServiceLineNote[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ExternalServiceLineNote[1]"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'InternalServiceLineNote'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/InternalServiceLineNote[1]))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/InternalServiceLineNote[1]"
						/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$p_attribute = 'UserName'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/UserName))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/UserName"
						/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="RemoveScientificNotation">
		<xsl:param name="p_input"/>
		<xsl:param name="p_dataType"/>
		<xsl:param name="p_dec"/>
		<!--Compute actual value by removing Scientific notation-->
		<xsl:variable name="v_result">
			<xsl:choose>
				<xsl:when test="matches($p_input, '^\-?[\d\.,]*[Ee][+\-]*\d*$')">
					<xsl:value-of select="format-number(number($p_input), '#0.#############')"
					> </xsl:value-of>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string($p_input)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--Format the result in required format-->
		<xsl:choose>
			<xsl:when test="$p_dataType = 'NUM' or $p_dataType = 'CURR'">
				<!--Append ZEROs to the result-->
				<xsl:choose>
					<xsl:when test="number($p_dec) = 0 or $p_dec = ''">
						<xsl:value-of select="$v_result"/>
					</xsl:when>
					<xsl:when test="not(matches(string($v_result), '\.'))">
						<xsl:variable name="v_decplaces">
							<xsl:value-of
								select="substring('000000000000000000000000000000', 1, number($p_dec))"
							/>
						</xsl:variable>
						<xsl:value-of select="concat($v_result, '.', $v_decplaces)"/>
					</xsl:when>
					<xsl:when
						test="string-length(substring-after($v_result, '.')) &lt; number($p_dec)">
						<xsl:variable name="v_decplaces">
							<xsl:value-of
								select="substring('000000000000000000000000000000', 1, number(number($p_dec) - string-length(substring-after($v_result, '.'))))"
							/>
						</xsl:variable>
						<xsl:value-of select="concat(string($v_result), $v_decplaces)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$v_result"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$p_dataType = 'DATE'">
				<xsl:value-of
					select="concat(substring($v_result, 7, 2), '-', substring($v_result, 5, 2), '-', substring($v_result, 1, 4))"
				/>
			</xsl:when>
			<xsl:when test="$p_dataType = 'TIME'">
				<xsl:choose>
					<xsl:when test="string-length($v_result) = 5">
						<xsl:value-of
							select="concat('0', substring($v_result, 1, 1), ':', substring($v_result, 2, 2), ':', substring($v_result, 4, 2))"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat(substring($v_result, 1, 2), ':', substring($v_result, 3, 2), ':', substring($v_result, 5, 2))"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildTimestamp">
		<xsl:param name="p_date"/>
		<xsl:param name="p_time"/>
		<xsl:if test="$p_date != ''">
			<xsl:variable name="v_date"
				select="concat(substring($p_date, 1, 4), '-', substring($p_date, 5, 2), '-', substring($p_date, 7, 2))"/>
			<xsl:variable name="v_time"
				select="concat(substring($p_time, 1, 2), ':', substring($p_time, 3, 2), ':', substring($p_time, 5, 2))"/>
			<xsl:value-of select="concat($v_date, 'T', $v_time)"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ArticleMaster">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_attribute"/>
		<xsl:if test="$p_attribute = 'External'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/External)"
			/>
		</xsl:if>
		<xsl:if test="$p_attribute = 'BomUsage'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/BomUsage)"
			/>
		</xsl:if>
		<xsl:if test="$p_attribute = 'EANCategory'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/EANCategory)"
			/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Convert_UTC_cXML_Supplier">
		<xsl:param name="p_utcTime"/>
		<xsl:value-of select="concat(substring($p_utcTime, 0, 20), '+00:00')"/>
	</xsl:template>
	<!-- Begin of IG-17553 for getting line level attachments & multiple attachments at both header and line item level -->	
	<!-- for Inbound multiple attachments -->
	<xsl:template name="InboundMultiAttIdoc_Common">
		<!-- Begin of IG-20169 -->
		<!-- Map multiple attachments from cXML to IDOC  -->
		<!-- Takes all the attachments from the cXML including the payload as cXML and PDF  -->
		<!-- and map it to the <E1ARBCIG_ATTACH_HDR_DET> segments in the IDOC.  -->
		<!-- The header attachment will be mapped first then the attachments at the lines.  -->
		<!-- If the payload is sent as an attachment (*.xml or *.pdf), this will be done    -->
		<!-- after the header and line/s attachments.                                       -->
		<!-- Header attachments details with no line numbers will be in the variable "headerAtt" -->
		<!-- Line attachments details with line numbers will be in the variable "lineReference"  -->
		<!-- input   headerAtt         : All attachments at header level
			         lineReference     : All attachments at line level along with line numbers			      		             
             output         	       : Attachments segments <E1ARBCIG_ATTACH_HDR_DET> in the IDOC -->
		<!-- End of IG-20169 -->
		<xsl:param name="headerAtt"/>
		<xsl:param name="lineReference"/>
		<xsl:variable name="attList" select="AttachmentList"/>
		<!-- Begin of IG-20169 -->
		<!-- get all the attachment ID of the header and line attachment -->
		<xsl:variable name="allAttachmentsWithCid">
			<xsl:for-each select="$headerAtt">
				<xsl:value-of select="concat(substring-after(.,'cid:'),',')"/>
			</xsl:for-each>
			<xsl:for-each select="$lineReference">
				<xsl:value-of select="concat(substring-after(.,'cid:'),',')"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- End of IG-20169 -->
		<xsl:for-each select="$headerAtt">
			<xsl:if test="contains(., 'cid:')">
				<xsl:variable name="cid" select="substring-after(., 'cid:')"/>
				<xsl:variable name="selectedAtt"
					select="$attList/Attachment[AttachmentID = $cid]"/>
				<xsl:for-each select="$selectedAtt">
				<E1ARBCIG_ATTACH_HDR_DET>
					<xsl:attribute name="SEGMENT">1</xsl:attribute>
					<FILENAME>
						<xsl:value-of select="AttachmentName"/>
					</FILENAME>
					<CONTENTTYPE>
						<xsl:value-of select="AttachmentType"/>
					</CONTENTTYPE>
					<CONTENTID>
						<xsl:value-of select="AttachmentID"/>
					</CONTENTID>
					<xsl:call-template name="splitAttContentIdoc_Common">
						<xsl:with-param name="content" select="AttachmentContent"/>
					</xsl:call-template>
				</E1ARBCIG_ATTACH_HDR_DET>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="$lineReference">
			<xsl:variable name="index" select="position()"/>
			<xsl:if test="contains(., 'cid:')">
				<xsl:variable name="cid" select="substring-after(., 'cid:')"/>
				<xsl:variable name="selectedAtt"
					select="$attList/Attachment[AttachmentID = $cid]"/>
				<xsl:for-each select="$selectedAtt">
				<E1ARBCIG_ATTACH_HDR_DET>
					<xsl:attribute name="SEGMENT">1</xsl:attribute>
					<FILENAME>
						<xsl:value-of select="AttachmentName"/>
					</FILENAME>
					<CONTENTTYPE>
						<xsl:value-of select="AttachmentType"/>
					</CONTENTTYPE>
					<CONTENTID>
						<xsl:value-of select="AttachmentID"/>
					</CONTENTID>
					<LINENUMBER>
						<xsl:call-template name="getLineNo_Common">
							<xsl:with-param name="array" select="$lineReference"/>
							<xsl:with-param name="index" select="$index"/>
						</xsl:call-template>
					</LINENUMBER>
					<xsl:call-template name="splitAttContentIdoc_Common">
						<xsl:with-param name="content" select="AttachmentContent"/>
					</xsl:call-template>						
				</E1ARBCIG_ATTACH_HDR_DET>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
		<!-- Begin of IG-20169 -->
		<!-- If the payload is sent as an attachment (*.xml or *.pdf), there will be no CID. -->
		<!-- However these will be present in the payload. Loop through all the attachments  -->
		<!-- coming in the payload and print only those that do not have a CID. Header and   -->
		<!-- Line attachment have already been printed in the above section of the code      -->
		<xsl:for-each select="$attList/Attachment">
			<xsl:if test="not(contains($allAttachmentsWithCid,AttachmentID))">
				<E1ARBCIG_ATTACH_HDR_DET>
					<xsl:attribute name="SEGMENT">1</xsl:attribute>
					<FILENAME>
						<xsl:value-of select="AttachmentName"/>
					</FILENAME>
					<CONTENTTYPE>
						<xsl:value-of select="AttachmentType"/>
					</CONTENTTYPE>
					<CONTENTID>
						<xsl:value-of select="AttachmentID"/>
					</CONTENTID>
					<xsl:call-template name="splitAttContentIdoc_Common">
						<xsl:with-param name="content" select="AttachmentContent"/>
					</xsl:call-template>
				</E1ARBCIG_ATTACH_HDR_DET>
			</xsl:if>
		</xsl:for-each>	
		<!-- End of IG-20169 -->
	</xsl:template>
	<xsl:template name="getLineNo_Common">
		<xsl:param name="array"/>
		<xsl:param name="index"/>
		<xsl:choose>
			<xsl:when test="contains($array[$index - 1], 'cid:')">
				<xsl:call-template name="getLineNo_Common">
					<xsl:with-param name="array" select="$array"/>
					<xsl:with-param name="index" select="$index - 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$array[$index - 1]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="splitAttContentIdoc_Common">
		<!-- Split the attachment contents from cXML to IDOC  -->
		<!-- Takes all the attachment contensts from the cXML including the payload as *.PDF  -->
		<!-- and *.cXML and map it to the <E1ARBCIG_ATTACH_CONTENT_DET> segments in the IDOC. -->
		<!-- IDOC has a limitation of 1000 characters in the <CONTENT> field. The IDOC segment-->
		<!-- <E1ARBCIG_ATTACH_CONTENT_DET> will be repeated after every 1000 characters.      -->		
		<!-- input   content           : All attachment contents of both header and line level		      		             
             output         	       : Attachment content segments <E1ARBCIG_ATTACH_CONTENT_DET> in the IDOC
             ________________________________________________________________________________________________
             template used by          : splitAttContentIdoc_Common (recursive call)
                                       : InboundMultiAttIdoc_Common
		-->
		<xsl:param name="content"/>
		<xsl:variable name="line-length" select="1000"/>
		<xsl:variable name="line" select="substring($content, 1, $line-length)"/>
		<xsl:variable name="rest" select="substring($content, $line-length + 1)"/>
		<xsl:if test="$line">
			<E1ARBCIG_ATTACH_CONTENT_DET>
				<xsl:attribute name="SEGMENT">1</xsl:attribute>
				<CONTENT>
					<xsl:value-of select="$line"/>
				</CONTENT>
			</E1ARBCIG_ATTACH_CONTENT_DET>
		</xsl:if>
		<xsl:if test="$rest">
			<xsl:call-template name="splitAttContentIdoc_Common">
				<xsl:with-param name="content" select="$rest"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>    
	<!-- End of IG-17553 -->	
<!--Template to Map TaxCatergories on Incoming FI Invoice Documents-->
	<xsl:template name="TaxTypeMap">
		<xsl:param name="p_taxcat"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anReceiverID"/>
		<xsl:param name="p_anSourceDocumentType"/>
<!--Mapping the Tax Type, in case any tax type is mainatined in the Look Up consider that value, 
    if not map the below default values respectively-->
		<xsl:variable name="v_mwskz">
			<xsl:call-template name="LookupTemplate">
				<xsl:with-param name="p_anERPSystemID" select="$p_anERPSystemID"/>
				<xsl:with-param name="p_anSupplierANID" select="$p_anReceiverID"/>
				<xsl:with-param name="p_producttype" select="'AribaNetwork'"/>
				<xsl:with-param name="p_doctype" select="$p_anSourceDocumentType"/>
				<xsl:with-param name="p_lookupname" select="'TaxCategoryMatchingType'"/>
				<xsl:with-param name="p_input" select="$p_taxcat"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($v_mwskz) &gt; 0">
				<xsl:value-of select="$v_mwskz"/>
			</xsl:when>
			<!--Sales Tax -->
			<xsl:when test='$p_taxcat = "sales"'>
				<xsl:value-of select="'SAL'"/>
			</xsl:when>
			<!-- Usage-->
			<xsl:when test='$p_taxcat = "usage"'>
				<xsl:value-of select="'USE'"/>
			</xsl:when>
			<!-- GST-->
			<xsl:when test='$p_taxcat = "gst"'>
				<xsl:value-of select="'GST'"/>
			</xsl:when>
			<!--HST-->
			<xsl:when test='$p_taxcat = "hst"'>
				<xsl:value-of select="'HST'"/>
			</xsl:when>
			<!--PST-->
			<xsl:when test='$p_taxcat = "pst"'>
				<xsl:value-of select="'PST'"/>
			</xsl:when>
			<!-- QST-->
			<xsl:when test='$p_taxcat = "qst"'>
				<xsl:value-of select="'QST'"/>
			</xsl:when>
			<!--VAT-->
			<xsl:when test='$p_taxcat = "vat"'>
				<xsl:value-of select="'VAT'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$p_taxcat"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!--	Mapping Address ID and Contact details; This is used in Incoming FI Invoice-->
	<xsl:template name="MapPartyDetails">
		<xsl:param name="p_contactDetails"/>  
		<xsl:if test="string-length($p_contactDetails/@addressID) > 0">
			<InternalID>
				<xsl:value-of select="$p_contactDetails/@addressID"/>
			</InternalID>
		</xsl:if>
		<xsl:if test="string-length($p_contactDetails/Name) > 0">
			<Address>
				<OrganisationFormOfAddress>
					<Name>
						<!-- IG-37398, Integration of IG-37266 -->
						<xsl:value-of select="substring($p_contactDetails/Name, 1, 40)"/>
					</Name>
				</OrganisationFormOfAddress>                            
			</Address>
		</xsl:if>    
	</xsl:template>
	
	<!-- Split the multiple lines in comments only for Header  -->
	<xsl:template name="CommentsFillIDOCOutSplitLine">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$p_aribaComment != ''">
			<xsl:for-each select="$p_aribaComment">
				<xsl:if test="exists(TDLINE)">
					<xsl:value-of
						select="concat('&#xa;', normalize-space(TDLINE))"/>
				</xsl:if>
			</xsl:for-each>							
		</xsl:if>
	</xsl:template> 
	
	
	<xsl:template name="MapMultiple_Text_Comments_IDOC_To_cXML">
		<!-- Map multiple comments from IDOC to cXML  -->
		<!-- Takes all the comments and attachment from the IDOC and creates as many <Comments>  -->
		<!-- segments in the cXML as there are comments in E1EDKT1/E1EDPT1/E1EDCT1  -->
		<!-- Attachments will only be created to the first <Comment> segment  -->
		<!-- input  p_aribaComment	       : Comment Segment from IDOC E1EDKT1/E1EDPT1/E1EDCT1
			        p_itemNumber           : Line Number(POSEX)
			        p_targetdoctype        : Target Document Type (OrderRequest)
			        p_sourcedoctype        : Source Document Type (Order/SchedulingAgreement)
			        p_pd                   : Cross Reference Parameter  
			        p_onlyattachnocomments : Variable for checking if Attachments exists
			        p_attach               : Attachment Content <E1ARBCIG_ATTACH_HDR_DET> segment from the IDOC			             
             output              	       : cXML message with <Comments><Attachments> 	-->
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_targetdoctype"/>
		<xsl:param name="p_sourcedoctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_onlyattachnocomments"/>
		<xsl:param name="p_attach"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:variable name="v_textID">
				<xsl:choose>
					<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $p_itemNumber != ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/LineTextID)"
						/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and normalize-space($p_itemNumber) = ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/HeaderTextID)"
						/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order' and $p_itemNumber != ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/LineTextIDPO)"
						/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order' and normalize-space($p_itemNumber) = ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/HeaderTextIDPO)"
						/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $p_itemNumber != ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/LineTextID[1])"
						/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and normalize-space($p_itemNumber)= ''">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_targetdoctype]/HeaderTextID[1])"
						/>	
					</xsl:when>									
				</xsl:choose>
			</xsl:variable>
			<!-- Check if the TDID in the IDOC to exists in the cross reference  -->
			<!-- IG-20409 Begin  -->
			<xsl:variable name="v_ifIDOCTextIDExistsCrossRef">
				<xsl:choose>
					<xsl:when test="$p_sourcedoctype = 'QuoteRequest'">
						<xsl:for-each select="$p_aribaComment/TDID">
							<xsl:if test="contains($v_textID,.)">
								<xsl:value-of select="'TRUE'"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order'">
						<xsl:for-each select="$p_aribaComment/TDID">
							<xsl:if test="contains($v_textID,.)">
								<xsl:value-of select="'TRUE'"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and string-length($p_itemNumber) = 0">
						<xsl:for-each select="$p_aribaComment[TDOBJECT = 'EKKO']/TDID">
							<xsl:if test="contains($v_textID,.)">
								<xsl:value-of select="'TRUE'"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and string-length($p_itemNumber) > 0">
						<xsl:for-each select="$p_aribaComment[TDOBJECT = 'EKPO'][ITEMNUMBER = $p_itemNumber]/TDID">
							<xsl:if test="contains($v_textID,.)">
								<xsl:value-of select="'TRUE'"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>				
			</xsl:variable>
			<!-- IG-20409 End  -->
			<!-- IG-20409 Use $v_ifIDOCTextIDExistsCrossRef to check for Comments and Attachments   -->
			<xsl:choose>
				<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $p_aribaComment/TDID and $p_itemNumber = '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_header"/>						
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $p_aribaComment = E1EDPT1 and $p_itemNumber != '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_line"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $p_aribaComment = E1EDCT1  and $p_itemNumber != '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_service_line"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'Order' and $p_aribaComment/TDID and $p_itemNumber = '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_header"/>						
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'Order' and $p_aribaComment = E1EDPT1 and $p_itemNumber != '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_line"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'Order' and $p_aribaComment = E1EDCT1  and $p_itemNumber != '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_service_line"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $p_itemNumber = '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_header"/>
						<xsl:with-param name="transaction" select="'SchedulingAgreement'"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when
					test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $p_aribaComment[ITEMNUMBER = $p_itemNumber] and $p_itemNumber != '' and $v_textID != '' and string-length($v_ifIDOCTextIDExistsCrossRef) > 0">
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string" select="$v_textID"/>
						<xsl:with-param name="pattern" select="','"/>
						<xsl:with-param name="comments" select="$p_aribaComment"/>
						<xsl:with-param name="attachment" select="$p_attach"/>
						<xsl:with-param name="onlyattachnocomments"  select="$p_onlyattachnocomments"/>
						<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
						<xsl:with-param name="commentlevel" select="$commentlevel_line"/>
						<xsl:with-param name="transaction" select="'SchedulingAgreement'"/>
						<xsl:with-param name="multicommentattachment_level" select="1"/>
					</xsl:call-template>
				</xsl:when>				
			</xsl:choose>
			<!-- Check if only Attachments are in the IDOC payload with no Comments -->
			<!-- IG-20409 Use $v_ifIDOCTextIDExistsCrossRef to check for attachments with no Comments   -->
			<xsl:variable name="v_onlyattachnocomments">
				<xsl:choose>
					<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and  $p_itemNumber = '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $p_itemNumber != '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order' and  $p_itemNumber = '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order' and $p_itemNumber != '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'Order' and $p_itemNumber != '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $p_itemNumber = '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>
					</xsl:when>
					<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $p_itemNumber != '' and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
						<xsl:value-of select="'1'"/>					
					</xsl:when>
				</xsl:choose>
			</xsl:variable>	
			<!-- Map only Attachments when no Comments are found -->
			<!-- IG-20409 Use $v_ifIDOCTextIDExistsCrossRef to check for attachments with no Comments   -->
			<xsl:choose>
				<xsl:when test="$p_sourcedoctype = 'QuoteRequest' and $v_onlyattachnocomments ='1' and string-length($p_onlyattachnocomments) > 0 and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
					<Comments xml:lang="">
						<xsl:call-template name="addContenIdIDOC">
							<xsl:with-param name="eachAtt" select="$p_attach"/>
							<xsl:with-param name="lineNumber" select="$p_itemNumber"/>
						</xsl:call-template>
					</Comments>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'Order' and $v_onlyattachnocomments ='1' and string-length($p_onlyattachnocomments) > 0 and string-length($v_ifIDOCTextIDExistsCrossRef) = 0">
					<Comments xml:lang="">
						<xsl:call-template name="addContenIdIDOC">
							<xsl:with-param name="eachAtt" select="$p_attach"/>
							<xsl:with-param name="lineNumber" select="$p_itemNumber"/>
						</xsl:call-template>
					</Comments>
				</xsl:when>
				<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $v_onlyattachnocomments ='1' and string-length($p_onlyattachnocomments) > 0 and (not($p_aribaComment[TDOBJECT = 'EKKO']) or ($p_aribaComment[TDOBJECT = 'EKKO'] and string-length($v_ifIDOCTextIDExistsCrossRef) = 0)) and $p_itemNumber = ''">
					<Comments xml:lang="">
						<xsl:call-template name="addContenIdIDOC">
							<xsl:with-param name="eachAtt" select="$p_attach"/>
							<xsl:with-param name="lineNumber" select="$p_itemNumber"/>
						</xsl:call-template>
					</Comments>
				</xsl:when>		
				<xsl:when test="$p_sourcedoctype = 'ScheduleAgreementRelease' and $v_onlyattachnocomments ='1' and string-length($p_onlyattachnocomments) > 0 and (not($p_aribaComment[ITEMNUMBER = $p_itemNumber][TDOBJECT = 'EKPO']) or ($p_aribaComment[ITEMNUMBER = $p_itemNumber][TDOBJECT = 'EKPO'] and string-length($v_ifIDOCTextIDExistsCrossRef) = 0)) and $p_itemNumber !=''">
					<Comments xml:lang="">
						<xsl:call-template name="addContenIdIDOC">
							<xsl:with-param name="eachAtt" select="$p_attach"/>
							<xsl:with-param name="lineNumber" select="$p_itemNumber"/>
						</xsl:call-template>
					</Comments>
				</xsl:when>		
			</xsl:choose>						
		</xsl:if>
	</xsl:template>
	<!-- Long Text Transfer for Proxy Outbound Transactions via CIG	 -->
	<xsl:template name="MapMultiple_Text_Comments_Proxy_To_cXML">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_trans"/>
		<xsl:variable name="v_arbcom" select="$p_itemNumber"/>
		<xsl:if test="$p_aribaComment != '' and $anCrossRefFlag = 'YES'">
			<!-- calling the binary PD to get the CROSS REF  -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!--  Read TextId from PD  -->
			<xsl:variable name="v_textID">
				<xsl:choose>
					<!-- This is for Dispatch Delivery notification Transaction	 -->
					<xsl:when test="$p_trans = 'DDN'">
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextIDDDN)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextIDDDN)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$p_itemNumber != ''">
								<xsl:value-of select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!--  Filter the HeaderTextID from PD values  -->
			<!-- For DispatchDeliveryNotification-->
			<xsl:choose>
				<xsl:when test="$p_trans = 'DDN'">
					<!--  Filter the HeaderTextID from PD values  -->
					<xsl:if
						test="$p_aribaComment[not(ItemNumber)] and $p_itemNumber = '' and $v_textID != ''">
						<xsl:attribute name="xml:lang">
							<xsl:for-each
								select="$p_aribaComment[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]/TextLang">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:attribute name="type">
							<xsl:for-each
								select="$p_aribaComment[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]/TextDesc">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:for-each
							select="$p_aribaComment[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]">
							<xsl:for-each select="AribaLine">
								<xsl:choose>
									<xsl:when test="position() = 1">
										<xsl:value-of select="concat(' ', TextLine)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="TextFormat = '* ' or '/ '">
											<xsl:choose>
												<xsl:when test="exists(TextLine)">
													<xsl:value-of
														select="concat('&#xA;', normalize-space(TextLine))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#10;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:if>
				</xsl:when>
				<!-- For SSR,SES,PR-->
				<xsl:otherwise>
					<xsl:if
						test="$p_aribaComment/Item[not(ItemNumber)] and $p_itemNumber = '' and $v_textID != ''">
						<xsl:attribute name="xml:lang">
							<xsl:for-each
								select="$p_aribaComment/Item[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]/TextLang">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:for-each
							select="$p_aribaComment/Item[not(ItemNumber) and contains($v_textID, normalize-space(TextID))]">
							<xsl:variable name="v_desc">
								<xsl:value-of select="concat(TextDesc, ':', '&#xA;')"/>
							</xsl:variable>
							<xsl:for-each select="AribaLine">
								<xsl:choose>
									<xsl:when test="position() = 1">
										<xsl:choose>
											<xsl:when test="string-length($v_desc) > 1">
												<xsl:text>&#xa;</xsl:text>
												<xsl:value-of
													select="concat(' ', $v_desc, TextLine)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(' ', TextLine)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="TextFormat = '* ' or '/ '">
											<xsl:choose>
												<xsl:when test="exists(TextLine)">
													<xsl:value-of
														select="concat('&#xA;', normalize-space(TextLine))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#10;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<!--  Filter the LineTextID from PD values  -->
			<!-- For DispatchDeliveryNotification-->
			<xsl:choose>
				<xsl:when test="$p_trans = 'DDN'">
					<xsl:if
						test="$p_aribaComment[ItemNumber = $p_itemNumber] and $p_itemNumber = ItemNumber and $v_textID != ''">
						<xsl:attribute name="xml:lang">
							<xsl:for-each
								select="$p_aribaComment[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]/TextLang">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:attribute name="type">
							<xsl:for-each
								select="$p_aribaComment[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]/TextDesc">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:for-each
							select="$p_aribaComment[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]">
							<xsl:for-each select="AribaLine">
								<xsl:choose>
									<xsl:when test="position() = 1">
										<xsl:value-of select="concat(' ', TextLine)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="TextFormat = '* ' or '/ '">
											<xsl:choose>
												<xsl:when test="exists(TextLine)">
													<xsl:value-of
														select="concat('&#xA;', normalize-space(TextLine))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#10;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:if>
				</xsl:when>
				<!-- For SSR,SES,PR-->
				<xsl:otherwise>
					<xsl:if
						test="$p_aribaComment/Item[ItemNumber = $p_itemNumber] and $p_itemNumber != '' and $v_textID != ''">
						<xsl:attribute name="xml:lang">
							<xsl:for-each
								select="$p_aribaComment/Item[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]/TextLang">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:for-each
							select="$p_aribaComment/Item[ItemNumber = $p_itemNumber and contains($v_textID, normalize-space(TextID))]">
							<xsl:variable name="v_desc">
								<xsl:choose>
									<xsl:when test="exists(TextDesc)">
										<xsl:value-of select="concat(TextDesc, ':', '&#xA;')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('Long Text', ':', '&#xA;')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:for-each select="AribaLine">
								<xsl:choose>
									<xsl:when test="position() = 1">
										<xsl:choose>
											<xsl:when test="string-length($v_desc) > 1">
												<xsl:text>&#xa;</xsl:text>
												<xsl:value-of
													select="concat(' ', $v_desc, TextLine)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(' ', TextLine)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="TextFormat = '* ' or '/ '">
											<xsl:choose>
												<xsl:when test="exists(TextLine)">
													<xsl:value-of
														select="concat('&#xA;', normalize-space(TextLine))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#10;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="MapMultiple_Text_Comments_To_cXML_Split">
		<!-- MapMultiple Text Comments To cXML Split  -->
		<!-- Takes all the comments and attachment from the IDOC and reads the text IDS from the -->
		<!-- cross reference parameter to create <Comments>  segments in the cXML as there are   -->
		<!-- comments in E1EDKT1/E1EDPT1/E1EDCT1 and text IDS from the cross reference parameters-->
		<!-- Attachments will only be created to the first <Comment> segment  -->
		<!-- input  remaining-string	         : All the TextIDs from cross reference parameters
			        pattern                      : comma(,) since the cross reference parameters are separated by , 
			        comments                     : comments segment from the IDOC E1EDKT1/E1EDPT1/E1EDCT1
			        attachment                   : attachments from the IDOC under <E1ARBCIG_ATTACH_HDR_DET>			        
			        onlyattachnocomments         : indicator that shows that only attachments are present in IDOC
			        itemNumber                   : PO line number
			        commentlevel                 : Comments at line or header level indicator
			        transaction                  : Orders or ScedulingAgreement transaction indicator
			        multicommentattachment_level : Indiator to have attachments only at first <Comments> segment
             output              	             : cXML message with <Comments><Attachments> 	-->
		<xsl:param name="remaining-string"/>
		<xsl:param name="pattern"/>
		<xsl:param name="comments"/>
		<xsl:param name="attachment"/>
		<xsl:param name="onlyattachnocomments"/>
		<xsl:param name="itemNumber"/>
		<xsl:param name="commentlevel"/>
		<xsl:param name="transaction"/>
		<xsl:param name="multicommentattachment_level"/>
		<!-- Get the position of the <Comments>  -->
		<xsl:variable name="v_commentlevel">			
			<xsl:choose>
				<xsl:when test="string-length($transaction) = 0 and $comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="string-length($transaction) > 0 and $commentlevel= 'HEADER' and $comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKKO']">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="string-length($transaction) > 0 and $commentlevel= 'LINE' and $comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]">
					<xsl:value-of select="1"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- Check for PO or SA/SAR transaction   -->
		<xsl:if test="$transaction">
			<!-- SA/SAR transaction  -->
			<xsl:choose>
				<xsl:when test="contains($remaining-string, $pattern)">
					<xsl:variable name="v_comments_exists_sa_sar">
						<xsl:choose>
							<xsl:when test="$commentlevel= 'HEADER'">
								<xsl:value-of select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKKO']"/>
							</xsl:when>
							<xsl:when test="$commentlevel= 'LINE'">
								<xsl:value-of
									select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]"
								/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if
						test="string-length($v_comments_exists_sa_sar) > 0">
						<Comments>							
							<xsl:attribute name="type">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKKO']/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]/TDDESC"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKKO']/TSSPRAS_ISO"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]/TSSPRAS_ISO"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<!-- Get all the comments  -->
							<xsl:variable name="v_Comments">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:for-each
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKKO']">
											<xsl:for-each select="E1ARBCIG_LINES">
												<xsl:choose>					
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '*'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
													<!-- Same Line  -->
												<xsl:when test="TDFORMAT = '='">
												<!--IG-27121 - Fixed Blank Space Issue	-->
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:for-each
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]">
											<xsl:for-each select="E1ARBCIG_LINES">
												<xsl:choose>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '*'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
													<!-- Same Line  -->
												<xsl:when test="TDFORMAT = '='">
												<!--IG-27121 - Fixed Blank Space Issue	-->
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>							
							<xsl:value-of select="$v_Comments"/>
							
							<xsl:if test="$multicommentattachment_level = 1">
								<!-- Check if for first <Comments> segment , the add attachments for header  -->
								<xsl:if test="$commentlevel = $commentlevel_header">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Check if for first <Comments> segment , the add attachments for Line  -->
								<xsl:if test="$commentlevel = $commentlevel_line">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
										<xsl:with-param name="lineNumber" select="$itemNumber"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</Comments>
					</xsl:if>
					<!-- Set indicator for checking the position of the <Comments> segment  -->
					<xsl:variable name="v_attachment_at_first_level_only">
						<xsl:choose>
							<xsl:when test="string-length($v_commentlevel) > 0">
								<xsl:value-of
									select="$v_commentlevel + $multicommentattachment_level"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="0 + $multicommentattachment_level"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- Make recursive call if there are multiple text ids  -->
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string"
							select="substring-after($remaining-string, $pattern)"/>
						<xsl:with-param name="pattern" select="$pattern"/>
						<xsl:with-param name="comments" select="$comments"/>
						<xsl:with-param name="attachment" select="$attachment"/>
						<xsl:with-param name="commentlevel" select="$commentlevel"/>
						<xsl:with-param name="itemNumber" select="$itemNumber"/>
						<xsl:with-param name="transaction" select="'SchedulingAgreement'"/>
						<xsl:with-param name="multicommentattachment_level" select="$v_attachment_at_first_level_only"/>
					</xsl:call-template>

				</xsl:when>
				<xsl:otherwise>
					<!-- IG-40370, For last iteration where no more text IDs available, Check if comment exists for this text IDs For particualr Item/Header-->					
					<xsl:variable name="v_comments_exists_sar">
						<xsl:choose>
							<xsl:when test="$commentlevel= 'HEADER'">
								<xsl:value-of select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKKO']"/>
							</xsl:when>
							<xsl:when test="$commentlevel= 'LINE'">
								<xsl:value-of
									select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]"
								/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>	
					<!-- Instead of checking text ID in all the comments, we will check comment for particular line/header -->
					<xsl:if test="string-length($v_comments_exists_sar) > 0">
						<Comments>
							<xsl:attribute name="type">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKKO']/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]/TDDESC"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKKO']/TSSPRAS_ISO"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]/TSSPRAS_ISO"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$commentlevel = $commentlevel_header">
									<xsl:if
										test="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKKO']">
										<xsl:for-each
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKKO']">
											<xsl:for-each select="E1ARBCIG_LINES">
												<!-- Start of IG-41514  -->
												<xsl:choose>
													<!-- Same Line  -->
												<xsl:when test=" TDLINE and not(exists(TDFORMAT))">
													<xsl:value-of
														select="concat (' ', normalize-space(TDLINE))"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
													<!--IG-41412 : Pass only TDLINE instead of whole context-->
													<xsl:value-of
														select="concat('&#xA;', normalize-space(TDLINE))"/>
												</xsl:when>
													<!-- Blank Line  -->								
												<xsl:when
												test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
													<!-- Same Line  -->
												<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<!--IG-41412 : Pass only TDLINE instead of whole context-->
												<xsl:value-of
													select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
												</xsl:choose>
												<!-- End of IG-41514  -->
											</xsl:for-each>
										</xsl:for-each>
									</xsl:if>
								</xsl:when>
								<xsl:when test="$commentlevel = $commentlevel_line">
									<xsl:if
										test="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]">
										<xsl:for-each
											select="$comments[TDID = normalize-space($remaining-string)][TDOBJECT = 'EKPO'][ITEMNUMBER = $itemNumber]">
											<xsl:for-each select="E1ARBCIG_LINES">
												<!-- Start of IG-41514  -->
												<xsl:choose>
													<!-- Same Line  -->
												<xsl:when test=" TDLINE and not(exists(TDFORMAT))">
													<xsl:value-of select="concat (' ', normalize-space(TDLINE))"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
													<xsl:value-of select="concat('&#xA;', normalize-space(TDLINE))"/>
												</xsl:when>
													<!-- Blank Line  -->
												<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
													<xsl:value-of select="concat('&#xA;', normalize-space(TDLINE))"/>
												</xsl:when>
													<!-- Same Line  -->
												<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
													<!-- New Line  -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
												</xsl:choose>
												<!-- End of IG-41514  -->
											</xsl:for-each>
										</xsl:for-each>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="$multicommentattachment_level = 1">
								<!-- Check if for first <Comments> segment , the add attachments for Header  -->
								<xsl:if test="$commentlevel = $commentlevel_header">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Check if for first <Comments> segment , the add attachments for Line  -->
								<xsl:if test="$commentlevel = $commentlevel_line">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
										<xsl:with-param name="lineNumber" select="$itemNumber"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</Comments>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="string-length($transaction) = 0">
			<!-- Orders  -->
			<xsl:choose>
				<xsl:when test="contains($remaining-string, $pattern)">
					<xsl:if
						test="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]">
						<Comments>
							<xsl:attribute name="type">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]/E1ARBCIG_DESC/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]/E1ARBCIG_DESC_ITEM/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_service_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]/E1ARBCIG_DESC_SITEM/TDDESC"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="xml:lang">
								<xsl:value-of
									select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]/TSSPRAS_ISO"
								/>
							</xsl:attribute>
							<!-- Get the comments  -->
							<xsl:variable name="v_Comments">
								<xsl:for-each
									select="$comments[TDID = normalize-space(substring-before($remaining-string, $pattern))]">
									<xsl:variable name="v_desc">									
									</xsl:variable>
									<xsl:if test="$commentlevel = $commentlevel_header">
										<!--Header level Comments-->
										<xsl:for-each select="E1EDKT2">
											<xsl:choose>
												<!-- Same Line -->
											   <xsl:when test="TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											   </xsl:when>
												<!-- New Line -->
												<xsl:when test="TDFORMAT = '*' and (exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<!-- Blank Line -->
												<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											   </xsl:when>
												<!-- Same Line -->
												<xsl:when test="TDFORMAT = '='">
												<!--IG-27121 - Fixed Blank Space Issue	-->
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
												<!-- New Line -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:if>
									<!--Header level Comments-->
									<xsl:if test="$commentlevel = $commentlevel_line">
										<!--Line level Comments-->
										<xsl:for-each select="E1EDPT2">
											<xsl:choose>
												<!-- Same Line -->
											    <xsl:when test="TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											   </xsl:when>
												<!-- New Line -->
												<xsl:when test="TDFORMAT = '*' and (exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>													
												</xsl:when>
												<!-- Blank Line -->
												<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											   </xsl:when>
												<!-- Same Line -->
												<xsl:when test="TDFORMAT = '='">
												<!--IG-27121 - Fixed Blank Space Issue	-->
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
												<!-- New Line -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:if>
									<!--Line level Comments-->
									<xsl:if test="$commentlevel = $commentlevel_service_line">
										<!--Service Line level Comments-->
										<xsl:for-each select="E1EDCT2">
											<xsl:choose>
												<!-- Same Line -->
											    <xsl:when test=" TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											    </xsl:when>
												<!-- New Line -->
												<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"/>
												</xsl:when>
												<!-- Blank Line -->
												<xsl:when
												test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<!-- Same Line -->
												<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
												</xsl:when>
												<!-- New Line  -->
												<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:if>
									<!--Service Line level Comments-->
								</xsl:for-each>
							</xsl:variable>
							<xsl:value-of select="$v_Comments"/>
							<xsl:if test="$multicommentattachment_level = 1">
								<!-- Check if for first <Comments> segment , the add attachments for Header  -->
								<xsl:if test="$commentlevel = $commentlevel_header">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Check if for first <Comments> segment , the add attachments for Line  -->
								<xsl:if test="$commentlevel = $commentlevel_line">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
										<xsl:with-param name="lineNumber" select="$itemNumber"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</Comments>
					</xsl:if>
					<!-- Set indicator for checking the position of the <Comments> segment  -->				
					<xsl:variable name="v_attachment_at_first_level_only">
						<xsl:choose>
							<xsl:when test="string-length($v_commentlevel) > 0">
								<xsl:value-of
									select="$v_commentlevel + $multicommentattachment_level"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="0 + $multicommentattachment_level"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- Make recursive call if there are multiple text ids  -->
					<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
						<xsl:with-param name="remaining-string"
							select="substring-after($remaining-string, $pattern)"/>
						<xsl:with-param name="pattern" select="$pattern"/>
						<xsl:with-param name="comments" select="$comments"/>
						<xsl:with-param name="attachment" select="$attachment"/>
						<xsl:with-param name="commentlevel" select="$commentlevel"/>
						<xsl:with-param name="itemNumber" select="$itemNumber"/>
						<xsl:with-param name="multicommentattachment_level" select="$v_attachment_at_first_level_only"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$comments[TDID = normalize-space($remaining-string)]">
						<Comments>
							<xsl:attribute name="type">
								<xsl:choose>
									<xsl:when test="$commentlevel = $commentlevel_header">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)]/E1ARBCIG_DESC/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)]/E1ARBCIG_DESC_ITEM/TDDESC"
										/>
									</xsl:when>
									<xsl:when test="$commentlevel = $commentlevel_service_line">
										<xsl:value-of
											select="$comments[TDID = normalize-space($remaining-string)]/E1ARBCIG_DESC_SITEM/TDDESC"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="xml:lang">
								<xsl:value-of
									select="$comments[TDID = normalize-space($remaining-string)]/TSSPRAS_ISO"
								/>
							</xsl:attribute>
							<xsl:for-each
								select="$comments[TDID = normalize-space($remaining-string)]">
								<xsl:variable name="v_desc">
									<!--<xsl:if test="string-length(E1ARBCIG_DESC/TDDESC) > 0">
									<xsl:value-of select="concat(' ', E1ARBCIG_DESC/TDDESC, ':')"/>
								</xsl:if>-->
								</xsl:variable>
								<xsl:if test="$commentlevel = $commentlevel_header">
									<!--Header level Comments-->
									<xsl:for-each select="E1EDKT2">
										<xsl:choose>
											<!-- Same Line  -->
										   <xsl:when test=" TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- Blank Line  -->
											<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<!-- Same Line  -->
											<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:if>
								<!--Header level Comments-->
								<xsl:if test="$commentlevel = $commentlevel_line">
									<!--Line level Comments-->
									<xsl:for-each select="E1EDPT2">
										<xsl:choose>
											<!-- Same Line  -->
											<xsl:when test=" TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- Blank Line  -->
											<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<!-- Same Line  -->
											<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="$commentlevel = $commentlevel_line">
									<!--Service Line level Comments-->
									<xsl:for-each select="E1EDCT2">
										<xsl:choose>
											<!-- Same Line  -->
										   <xsl:when test=" TDLINE and not(exists(TDFORMAT))">
												<xsl:value-of
												select="concat (' ', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '*' and exists(TDLINE)">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"/>
											</xsl:when>
											<!-- Blank Line  -->
											<xsl:when test="TDFORMAT = '*' and not(exists(TDLINE))">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<!-- Same Line  -->
											<xsl:when test="TDFORMAT = '='">
												<xsl:value-of select="TDLINE"/>
											</xsl:when>
											<!-- New Line  -->
											<xsl:when test="TDFORMAT = '/'">
												<xsl:value-of
												select="concat('&#xA;', normalize-space(TDLINE))"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:if>
								<!--Service Line level Comments-->
							</xsl:for-each>
							<xsl:if test="$multicommentattachment_level = 1">
								<xsl:if test="$commentlevel = $commentlevel_header">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
									</xsl:call-template>
								</xsl:if>

								<xsl:if test="$commentlevel = $commentlevel_line">
									<xsl:call-template name="addContenIdIDOC">
										<xsl:with-param name="eachAtt" select="$attachment"/>
										<xsl:with-param name="lineNumber" select="$itemNumber"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
						</Comments>
					</xsl:if>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template> 
	<!--    Get the Default Language -->
	<xsl:template name="SendManufacturerName">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default Language from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SendManufacturerName)"
			/>
		</xsl:if>
	</xsl:template>
	<!--IG-23905 Send Payment Terms -->
	<xsl:template name="SendPaymentTerms">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default Language from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SendPaymentTerms)"
			/>
		</xsl:if>
	</xsl:template>
	<!--    IG-26224 Template for SpecialHandlingAmount --> 
	<!--    Get the SpecialHandlingAmount flag -->
	<xsl:template name="SpecialHandlingAmount">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>		
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read SpecialHandlingAmount from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SpecialHandlingAmount)"
			/>								
		</xsl:if>
	</xsl:template>	
	<!-- Begin of IG-17864 for getting line level attachments & multiple attachments at both header and line item level -->	
	<!-- for Inbound multiple attachments -->
	<xsl:template name="InboundMultiAttProxy_Common">
		<!-- Map multiple attachments from cXML to Proxy Structure -->
		<!-- Takes all the attachments from the cXML and map it to the <Attachment> segments -->
		<!-- in the Proxy Structure. The header attachment will be mapped first then the     -->
		<!-- attachments at the lines.                                                       -->
		<!-- Header attachments details with no line numbers will be in the variable "headerAtt" -->
		<!-- Line attachments details with line numbers will be in the variable "lineReference" -->
		<!-- input   headerAtt         : All attachments at header level
			         lineReference     : All attachments at line level along with line numbers			      		             
             output         	       : Attachments segments <E1ARBCIG_ATTACH_HDR_DET> in the IDOC 
		___________________________________________________________________________________________________________
		     template used by          : MAPPING_ANY_cXML_0000_OrderRequest_AddOn_0000_SalesOrderRequest.xsl
		                               : MAPPING_ANY_cXML_0000_ShipNoticeRequest_AddOn_0000_AdvanceShipmentNotice.xsl -->		
		<xsl:param name="headerAtt"/>
		<xsl:param name="lineReference"/>
		<xsl:variable name="attList" select="AttachmentList"/>
		<Attachment>
			<xsl:for-each select="$headerAtt">
				
				<xsl:if test="contains(., 'cid:')">
					<xsl:variable name="cid" select="substring-after(., 'cid:')"/>
					<xsl:variable name="selectedAtt"
						select="$attList/Attachment[AttachmentID = $cid]"/>
					<Item>
						<FileName>
							<xsl:value-of select="$selectedAtt/AttachmentName"/>
						</FileName>
						<ContentType>
							<xsl:value-of select="$selectedAtt/AttachmentType"/>
						</ContentType>
						<ContentId>
							<xsl:value-of select="$selectedAtt/AttachmentID"/>
						</ContentId>
						<Content>
							<xsl:value-of select="$selectedAtt/AttachmentContent"/>
						</Content>
					</Item>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="$lineReference">
				<xsl:variable name="index" select="position()"/>
				<xsl:if test="contains(., 'cid:')">
					<xsl:variable name="cid" select="substring-after(., 'cid:')"/>
					<xsl:variable name="selectedAtt"
						select="$attList/Attachment[AttachmentID = $cid]"/>
					<Item>
						<FileName>
							<xsl:value-of select="$selectedAtt/AttachmentName"/>
						</FileName>
						<ContentType>
							<xsl:value-of select="$selectedAtt/AttachmentType"/>
						</ContentType>
						<ContentId>
							<xsl:value-of select="$selectedAtt/AttachmentID"/>
						</ContentId>
						<Content>
							<xsl:value-of select="$selectedAtt/AttachmentContent"/>
						</Content>
						<LineNumber>
							<xsl:call-template name="getLineNo_Common">
								<xsl:with-param name="array" select="$lineReference"/>
								<xsl:with-param name="index" select="$index"/>
							</xsl:call-template>
						</LineNumber>
					</Item>
				</xsl:if>
			</xsl:for-each>
		</Attachment>
	</xsl:template>
	<!-- END of IG-17864 -->
	<!--	Begin of IG-30341 -->
	<!--	Supplier part id will be populated from CIG -->
	<!--	Blank will be populated if nothing is maintained-->
	<xsl:template name="defaultSupplierPartID">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default SupplierPartID from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/defaultSupplierPartID)"
			/>
		</xsl:if>
	</xsl:template>
	<!--	End of IG-30341   -->	
	<!-- START of IG-33868 -->
	<!-- Get Negative Quantity Flag  -->
	<xsl:template name="NegativeQuantity">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
						<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/NegativeQuantity)"
			/>
		</xsl:if>
	</xsl:template>
	<!-- END of IG-33868 -->
</xsl:stylesheet>
