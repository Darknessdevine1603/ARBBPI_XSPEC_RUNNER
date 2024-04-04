<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<!--	<xsl:variable name="crossrefparamLookup" select="document('ParameterCrossreference.xml')"/>
   <xsl:variable name="UOMLookup" select="document('UOMTemplate.xml')"/>-->
	<xsl:param name="anCrossRefFlag"/>
	<xsl:param name="anLookUpFlag"/>
	<xsl:param name="anUOMFlag"/>
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
				<xsl:value-of
					select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
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
				<xsl:value-of
					select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
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
				<xsl:value-of
					select="concat('pd', ':', $p_anSupplierANID, ':', $v_sysId, ':', 'Binary')"/>
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
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID"
						/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="v_LineTextId">
				<xsl:if test="$p_attribute = 'LineTextID'">
					<xsl:if
						test="(exists($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID))">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID"
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
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
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
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
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
						<xsl:with-param name="p_str" select="normalize-space($v_comments)"/>
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
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
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
					<xsl:with-param name="p_str" select="normalize-space($v_comments)"/>
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
		<xsl:if test="$v_str1">
			<E1ARBCIG_LINES SEGMENT="1">
				<TDLINE>
					<xsl:value-of select="$v_str1"/>
				</TDLINE>
			</E1ARBCIG_LINES>
		</xsl:if>
		<xsl:if test="$v_str2">
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
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
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
							<xsl:if test="string-length(E1ARBCIG_DESC/TDDESC) > 0">							
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
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Filter the HeaderTextID from PD values -->
			<!-- Use new Template for Scheduling Agreement -->
			<xsl:choose>
				<xsl:when test="$p_trans = 'PaymentRemittance' or $p_trans = 'MMInvoice'">
					<xsl:if test="$p_itemNumber = '' and $v_textID != ''">
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="$p_aribaComment[not(ItemNumber) and TextID = $v_textID]/TextLang"/>
							<xsl:for-each
								select="$p_aribaComment[not(ITEMNUMBER) and contains($v_textID, normalize-space(TDID))]/TDSPRAS_ISO">
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:attribute>
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
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$p_itemNumber = '' and $v_textID != ''">
						<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
							<xsl:with-param name="remaining-string" select="$v_textID"/>
							<xsl:with-param name="pattern" select="','"/>
							<xsl:with-param name="comments" select="$p_aribaComment"/>
							<xsl:with-param name="attachment" select="$p_attach"/>
							<xsl:with-param name="commentlevel" select="$commentlevel_header"/>
							<xsl:with-param name="transaction" select="'SchedulingAgreement'"/>
							<xsl:with-param name="multicommentattachment_level" select="1"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="$p_aribaComment[ITEMNUMBER = $p_itemNumber] and $p_itemNumber != '' and $v_textID != ''">
						<xsl:call-template name="MapMultiple_Text_Comments_To_cXML_Split">
							<xsl:with-param name="remaining-string" select="$v_textID"/>
							<xsl:with-param name="pattern" select="','"/>
							<xsl:with-param name="comments" select="$p_aribaComment"/>
							<xsl:with-param name="attachment" select="$p_attach"/>
							<xsl:with-param name="itemNumber" select="$p_itemNumber"/>
							<xsl:with-param name="commentlevel" select="$commentlevel_line"/>
							<xsl:with-param name="transaction" select="'SchedulingAgreement'"/>
							<xsl:with-param name="multicommentattachment_level" select="1"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CommentsFillProxyOut">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_trans"/>
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
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Filter the HeaderTextID from PD values -->
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
		<xsl:value-of select="concat('pd', ':', $p_ansupplierid, ':', $v_crossref, ':', 'Binary')"/>
	</xsl:template>
	<!--    Get the Default Language -->
	<xsl:template name="FillDefaultLang">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:if test="$anCrossRefFlag = 'YES'">
			<!--calling the binary PD to get the CROSS REF -->
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<!-- Read Default Language from PD -->
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/DefaultLang)"
			/>
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
	<!--Inbound attachment for IDOC -->
	<xsl:template name="InboundAttachIDOC">
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
	<xsl:te
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ore($remaining-string, $pattern))]/E1ARBCIG_DESC_SITEM/TDDESC"
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
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
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
												<xsl:value-of
												select="concat(' ', normalize-space(TDLINE))"/>
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
	<!-- Begin of IG-17864 for getting line level attachments & multiple attachments at both header and line item level -->	
	<!-- for Inbound multiple attachments -->
	<xsl:template name="InboundMultiAttProxy_Common">
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
</xsl:stylesheet>
