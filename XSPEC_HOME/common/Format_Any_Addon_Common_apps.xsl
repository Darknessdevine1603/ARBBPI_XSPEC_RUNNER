<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<!--<xsl:variable name="crossrefparamLookup" select="document('ParameterCrossreference.xml')"/>	
	<xsl:variable name="UOMLookup" select="document('UOMTemplate.xml')"/>-->
	<!-- UOM Template for inbound CIG to SAP -->
	<!--<xsl:variable name="LOOKUPTABLE" select="document('LookupTable.xml')"/>-->
	<xsl:template name="UOMTemplate_In">
		<xsl:param name="p_UOMinput"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anSenderID"/>
		<xsl:if test="$p_UOMinput != ''">
			<!--constructing the UOM string-->
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('UOM', '_', $p_anERPSystemID)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:value-of
					select="concat('pd', ':', $p_anSenderID, ':', $v_sysId, ':', 'Binary')"/>
			</xsl:variable>
			<!--calling the binary PD to get the UOM -->
			<xsl:variable name="UOMLookup" select="document($v_pd)"/>
			<xsl:choose>
				<xsl:when
					test="string-length($UOMLookup/UOM/ValueItems/Item[AribaValue = $p_UOMinput]/customerValue) &gt; 0">
					<xsl:value-of
						select="upper-case($UOMLookup/UOM/ValueItems/Item[AribaValue = $p_UOMinput]/customerValue)"
					/>
				</xsl:when>
				<xsl:otherwise>ZB00</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- Read LookUp Table Template -->
	<xsl:template name="ReadLookUpTable_In">
		<xsl:param name="p_erpsysid"/>
		<xsl:param name="p_ansupplierid"/>
		<xsl:param name="p_docType"/>
		<xsl:param name="p_lookupName"/>
		<xsl:param name="p_productType"/>
		<xsl:param name="p_input"/>
		<xsl:if test="$p_input != ''">
			<!--constructing the UOM string-->
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('LOOKUPTABLE', '_', $p_erpsysid)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:value-of
					select="concat('pd', ':', $p_ansupplierid, ':', $v_sysId, ':', 'Binary')"/>
			</xsl:variable>
			<!--calling the binary PD to get the UOM -->
						<xsl:variable name="LOOKUPTABLE" select="document($v_pd)"/>
			<xsl:choose>
				<xsl:when
					test="string-length($LOOKUPTABLE/LOOKUPTABLE/Parameter[DocumentType = $p_docType and Name = $p_lookupName and ProductType = $p_productType]/ListOfItems/Item[Name = $p_input]/Value) &gt; 0">
					<xsl:value-of
						select="$LOOKUPTABLE/LOOKUPTABLE/Parameter[DocumentType = $p_docType and Name = $p_lookupName and ProductType = $p_productType]/ListOfItems/Item[Name = $p_input]/Value"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when
							test="$p_docType = 'RequisitionExportRequest' and $p_lookupName = 'TaxOnCompanyCode'"
							>FALSE</xsl:when>
						<xsl:when
							test="$p_docType = 'PurchaseOrderExportRequest' and $p_lookupName = 'ProcurementConditionType'"
							>ZB00</xsl:when>
						<xsl:when
							test="$p_docType = 'PaymentExportRequest' and $p_lookupName = 'WithholdingTaxMap'">
							<xsl:value-of select="upper-case($p_input)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- Document Type -->
	<xsl:template name="FillDocType">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_ordCategory"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_itemCategory"/>
		<!--		create a flag param-->
		<!--calling the binary PD to get the CROSS REF -->
				<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<!-- Read Default Language from PD -->
		<xsl:choose>
			<xsl:when test="$p_ordCategory = 'ERP'">
				<xsl:choose>
					<xsl:when
						test="(($p_itemCategory = 'YES') and (string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)) > 0))">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)"
						/>
					</xsl:when>
					<!--<xsl:when
						test="(($p_itemCategory = 'YES') and (string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)) = 0))">
						<xsl:value-of select="'FO'"/>
					</xsl:when>-->
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>NB</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$p_ordCategory = 'INV'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>RE</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--Start of CI-681-->
			<!--CI-681 Logic for Subsequent Credit Document type-->
			<xsl:when test="$p_ordCategory = 'SCR'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPSubCreDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPSubCreDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>RA</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--CI-681 Logic for Subsequent Debit Document type-->
			<xsl:when test="$p_ordCategory = 'SDB'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPSubDebDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPSubDebDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>SU</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--End of CI-681-->
			<xsl:when test="$p_ordCategory = 'PR'">
				<!--test for limit order check item category = 'B' -->
				<xsl:choose>
					<xsl:when
						test="(($p_itemCategory = 'YES') and (string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)) > 0))">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)"
						/>
					</xsl:when>
					<!--<xsl:when
						test="(($p_itemCategory = 'YES') and (string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFODocType)) = 0))">
						<xsl:value-of select="'FO'"/>
					</xsl:when>-->
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>NB</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- Logic for fetching SAPFI DocumentType for NonPO Invoice -->
			<xsl:when test="$p_ordCategory = 'FIINV'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFIDocType)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFIDocType)"
						/>
					</xsl:when>
					<xsl:otherwise>KR</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- Logic for fetching SAPFI Indicator for NonPO Invoice -->
			<xsl:when test="$p_ordCategory = 'FIINV_IND'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFIIndicator)) > 0">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPFIIndicator)"
						/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when
						test="$p_ordCategory = 'ERPCC' or string-length(normalize-space($p_ordCategory)) = 0">
						<xsl:choose>
							<xsl:when
								test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPCCDocType)) > 0">
								<xsl:value-of
									select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/SAPCCDocType)"
								/>
							</xsl:when>
							<xsl:otherwise>AR</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$p_ordCategory"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
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
	<!-- Movement Type -->	
	<xsl:template name="FillMovType">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_acctDetail"/>
		<xsl:param name="p_pd"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<!--<xsl:variable name="crossrefparamLookup" select="document('ParameterCrossreference.xml')"/>	-->
		<!-- Read Default Language from PD -->
		<xsl:choose>
			<xsl:when test="$p_acctDetail = 'COSTCENTER'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/CosMvType)) > 0">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/CosMvType"
						/>
					</xsl:when>
					<xsl:otherwise>201</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$p_acctDetail = 'ORDERID'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/IntOrdMvType)) > 0">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/IntOrdMvType"
						/>
					</xsl:when>
					<xsl:otherwise>261</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$p_acctDetail = 'ASSET_NO'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AssetMvType)) > 0">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/AssetMvType"
						/>
					</xsl:when>
					<xsl:otherwise>241</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$p_acctDetail = 'WBS_ELEMENT'">
				<xsl:choose>
					<xsl:when
						test="string-length(normalize-space($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ProMvType)) > 0">
						<xsl:value-of
							select="$crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ProMvType"
						/>
					</xsl:when>
					<xsl:otherwise>221</xsl:otherwise>
				</xsl:choose>
			</xsl:when>		
		</xsl:choose>
	</xsl:template>
	<!-- Template Logic for Header and Item Text Split -->
	<xsl:template name="POTextSplit">
		<xsl:param name="p_doctype"/>
		<xsl:param name="str"/>
		<xsl:param name="strlen"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_textid"/>
		<xsl:param name="p_version"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<xsl:variable name="v_str" select="substring($str, 1, $strlen)"/>
		<xsl:variable name="v_strlen" select="substring($str, $strlen + 1)"/>
		<xsl:if test="$v_str">
			<item>
				<xsl:choose>
					<xsl:when test="$p_version = 'true'">
						<xsl:if test="$p_textid!= ''">
							<TEXT_ID>
								<xsl:value-of select="$p_textid"/>
							</TEXT_ID>
						</xsl:if>
						<xsl:if test="$p_textid= ''">
							<TEXT_ID>F01</TEXT_ID>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<TEXT_ID>F01</TEXT_ID>
					</xsl:otherwise>
				</xsl:choose>
				<TEXT_LINE>
					<xsl:value-of select="$v_str"/>
				</TEXT_LINE>
			</item>
		</xsl:if>
		<xsl:if test="$v_strlen">
			<xsl:call-template name="POTextSplit">
				<xsl:with-param name="str" select="$v_strlen"/>
				<xsl:with-param name="strlen" select="$strlen"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="HeaderCommentSplit">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_strcom"/>
		<xsl:param name="p_lencom"/>
		<xsl:param name="p_linecom"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_textid"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<xsl:variable name="v_strcom" select="substring($p_strcom, 1, $p_lencom)"/>
		<xsl:variable name="v_lencom" select="substring($p_strcom, $p_lencom + 1)"/>
		<xsl:variable name="v_linecom" select="$p_linecom"/>
		<xsl:variable name="v_doctype" select="$p_doctype"/>
		<xsl:if test="($v_doctype)">
			<xsl:if test="$v_strcom">
				<item>
					<TEXT_ID>
						<xsl:value-of select="$p_textid"/>
					</TEXT_ID>
					<TEXT_LINE>
						<xsl:value-of select="$v_strcom"/>
					</TEXT_LINE>
				</item>
			</xsl:if>
			<xsl:if test="$v_lencom">
				<xsl:call-template name="HeaderCommentSplit">
					<xsl:with-param name="p_doctype" select="$v_doctype"/>
					<xsl:with-param name="p_strcom" select="$v_lencom"/>
					<xsl:with-param name="p_lencom" select="$p_lencom"/>
					<xsl:with-param name="p_linecom" select="$v_linecom"/>
					<xsl:with-param name="p_textid" select="$p_textid"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="POTextLineSplit">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_linenum"/>
		<xsl:param name="p_linestr"/>
		<xsl:param name="p_linestrlen"/>
		<xsl:param name="p_pd"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<xsl:variable name="v_linestr1" select="substring($p_linestr, 1, $p_linestrlen)"/>
		<xsl:variable name="v_linestr2" select="substring($p_linestr, $p_linestrlen + 1)"/>
		<xsl:variable name="v_doctype" select="$p_doctype"/>
		<xsl:variable name="v_linenum" select="$p_linenum"/>
		<xsl:if test="$v_linestr1">
			<item>
				<PO_ITEM>
					<xsl:value-of select="$v_linenum"/>
				</PO_ITEM>
				<TEXT_ID>
					<xsl:value-of
						select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
					/>
				</TEXT_ID>
				<TEXT_LINE>
					<xsl:value-of select="$v_linestr1"/>
				</TEXT_LINE>
				<TEXT_FORM>X</TEXT_FORM>
				<ARIBA_ITEM_NO>
					<xsl:value-of select="$v_linenum"/>
				</ARIBA_ITEM_NO>
			</item>
		</xsl:if>
		<xsl:if test="$v_linestr2">
			<xsl:call-template name="POTextLineSplit">
				<xsl:with-param name="p_doctype" select="$v_doctype"/>
				<xsl:with-param name="p_linenum" select="$v_linenum"/>
				<xsl:with-param name="p_linestr" select="$v_linestr2"/>
				<xsl:with-param name="p_linestrlen" select="$p_linestrlen"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="POLineCommentSplit">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_strcom"/>
		<xsl:param name="p_lencom"/>
		<xsl:param name="p_linecom"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_textid"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
		<xsl:variable name="v_str1" select="substring($p_strcom, 1, $p_lencom)"/>
		<xsl:variable name="v_str2" select="substring($p_strcom, $p_lencom + 1)"/>
		<xsl:variable name="v_linecom" select="$p_linecom"/>
		<xsl:variable name="v_doctype" select="$p_doctype"/>
		<xsl:if test="($v_linecom)">
			<xsl:if test="$v_str1">
				<item>
					<PO_ITEM>
						<xsl:value-of select="$v_linecom"/>
					</PO_ITEM>
					<TEXT_ID>
						<xsl:value-of select="$p_textid"/>
					</TEXT_ID>
					<TEXT_LINE>
						<xsl:value-of select="$v_str1"/>
					</TEXT_LINE>
					<TEXT_FORM>
						<xsl:text disable-output-escaping="no">X</xsl:text>
					</TEXT_FORM>
					<ARIBA_ITEM_NO>
						<xsl:value-of select="$v_linecom"/>
					</ARIBA_ITEM_NO>
				</item>
			</xsl:if>
			<xsl:if test="$v_str2">
				<xsl:call-template name="POLineCommentSplit">
					<xsl:with-param name="p_doctype" select="$v_doctype"/>
					<xsl:with-param name="p_strcom" select="$v_str2"/>
					<xsl:with-param name="p_lencom" select="$p_lencom"/>
					<xsl:with-param name="p_linecom" select="$v_linecom"/>
					<xsl:with-param name="p_textid" select="$p_textid"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- ERPdateFormat -->
	<xsl:template name="ERPDateFormat">
		<xsl:param name="p_date"/>
		<xsl:if test="string-length(normalize-space($p_date)) > 0">
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
	<!--Prepare the CrossRef path-->
	<xsl:template name="PrepareCrossref">
		<xsl:param name="p_erpsysid"/>
		<xsl:param name="p_ansupplierid"/>
		<!--constructing the crossreference string-->
		<xsl:variable name="v_crossref">
			<xsl:value-of select="concat('CROSSREFERENCE', '_', $p_erpsysid)"/>
		</xsl:variable>
		<xsl:value-of select="concat('pd', ':', $p_ansupplierid, ':', $v_crossref, ':', 'Binary')"/>
	</xsl:template>

	<!--Inbound attachment for Proxy -->
	<xsl:template name="InboundAttach">
		<xsl:param name="lineReference"/>
		<xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
		<xsl:if test="$eachAtt">
			<ATTACHMENT>
				<xsl:for-each select="$eachAtt">
					<xsl:variable name="count" select="position()"/>
					<item>
						<FILE_NAME>
							<xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
						</FILE_NAME>
						<CONTENT_TYPE>
							<xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
						</CONTENT_TYPE>
						<CONTENT_ID>
							<xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
						</CONTENT_ID>
						<LINE_NUMBER>
							<xsl:call-template name="getAttLineNo">
								<xsl:with-param name="line" select="$lineReference"/>
								<xsl:with-param name="contentID"
									select="$eachAtt[$count]/AttachmentID"/>
							</xsl:call-template>
						</LINE_NUMBER>
						<CONTENT>
							<xsl:value-of select="$eachAtt[$count]/AttachmentContent"/>
						</CONTENT>
					</item>
				</xsl:for-each>
			</ATTACHMENT>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getAttLineNo">
		<xsl:param name="line"/>
		<xsl:param name="contentID"/>
		<xsl:variable name="cid" select="concat('cid:', $contentID)"/>
		<xsl:for-each select="$line">
			<xsl:variable name="ind" select="position()"/>
			<xsl:if test=". = $cid">
				<!-- Get the previous value -->
				<xsl:value-of select="$line[$ind - 1]"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="GetTextId">
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_commenttype"/>
		<!--calling the binary PD to get the CROSS REF -->
		<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>

		<xsl:if test="$p_commenttype = 'HeaderTextId'">
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
			/>
		</xsl:if>

		<xsl:if test="$p_commenttype = 'LineTextId'">
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
			/>
		</xsl:if>
		<xsl:if test="$p_commenttype = 'ServiceTextID'">
			<xsl:value-of
				select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ServiceTextID)"
			/>
		</xsl:if>
	</xsl:template>
<!--FormatUTCDate Template
Use this template to convert P2P UTC Format to ERP UTC Format.
For example YYYY-MM-DDTHH:MM:SSZ to ERP UTC Format YYYYMMDDHHMMSS-->
	<xsl:template name="formatUTCDate">
		<xsl:param name="p_UTCDate"/>
		<xsl:value-of select="concat(substring($p_UTCDate,1,4),
			substring($p_UTCDate,6,2),
			substring($p_UTCDate,9,2),
			substring($p_UTCDate,12,2),
			substring($p_UTCDate,15,2),
			substring($p_UTCDate,18,2))"/>        
	</xsl:template>
	
<!-- Outbound Comments for Proxy -->
	<xsl:template name="CommentsFillProxyOut">
		<xsl:param name="p_aribaComment"/>
		<xsl:param name="p_doctype"/>
		<xsl:param name="p_pd"/>
		<xsl:param name="p_itemNumber"/>
		<xsl:param name="IsServiceChild"/>
		<xsl:if test="$p_aribaComment != ''">
			<xsl:variable name="crossrefparamLookup" select="document($p_pd)"/>
			<xsl:variable name="v_textID">
				<xsl:choose>
					<xsl:when test="$p_itemNumber = ''">				
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/HeaderTextID)"
						/>				
					</xsl:when>
					<xsl:when test="$IsServiceChild = 'true'">
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/ServiceTextID)"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $p_doctype]/LineTextID)"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each
				select="$p_aribaComment/Item[contains($v_textID, normalize-space(TextID))]/AribaLine/TextLine">
				<xsl:choose>
					<xsl:when test="position() = 1">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(' ', .)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>	
</xsl:stylesheet>
