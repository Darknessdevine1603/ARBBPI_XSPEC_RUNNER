<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<!--<xsl:variable name="crossrefparamLookup" select="document('ParameterCrossreference.xml')"/>	
	<xsl:variable name="UOMLookup" select="document('UOMTemplate.xml')"/>-->
	<!-- UOM Template for inbound CIG to SAP -->
	<!--<xsl:variable name="LOOKUPTABLE" select="document('LookupTable.xml')"/>-->
	<xsl:param name="anLocalTesting"/>
	<xsl:template name="UOMTemplate_In">
		<!-- Read UoM Template -->
		<!-- This template is used to lookup entries w,r.t document type and correspondent lookup table-->
		<!-- 
		Input :
			  p_UOMinput          : Unit of Measurement as an input to the template
		      p_anERPSystemID     : ERP System ID such as Q8JCLNT002
		      p_anSenderID        : Sender ID AN02001565601:Q8JCLNT002:Binary for reading the table entry
		      
		Output:                   : Value maintained in the look up table or return default the values .
	    -->
		<xsl:param name="p_UOMinput"/>
		<xsl:param name="p_anERPSystemID"/>
		<xsl:param name="p_anSenderID"/>
		<xsl:if test="$p_UOMinput != ''">
			<!--constructing the UOM string-->
			<xsl:variable name="v_sysId">
				<xsl:value-of select="concat('UOM', '_', $p_anERPSystemID)"/>
			</xsl:variable>
			<xsl:variable name="v_pd">
				<xsl:choose>
					<xsl:when test="$anLocalTesting ='YES'">
						<xsl:value-of
							select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/UOM.xml'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('pd', ':', $p_anSenderID, ':', $v_sysId, ':', 'Binary')"/>
					</xsl:otherwise>
				</xsl:choose>				
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
	
	<xsl:template name="ReadLookUpTable_In">
		<!-- Read LookUp Table Template -->
		<!-- This template is used to lookup entries w,r.t document type and correspondent lookup table-->
		<!-- 
		Input :
		      p_erpsysid          : System ID such as Q8JCLNT002
		      p_ansupplierid      : pd:AN02001565601:Q8JCLNT002:Binary for reading the table entry
		      p_doctype           : Document type e.g. PurchaseOrderRequest and RequisitionExportRequest
		      p_lookupName        : Lookup table name where entries are maintained such as TaxOnCompanyCode and ProcurementConditionType
		      p_productType       : Ariba Solution such as AribaProcurement, AribaSourcing etc
		      p_input             : Input string for which value is to be match inorder to fetch the correspondent values
		      
		Output:                   : Value maintained in the look up table or default the values incase lookuptable are not maintained such ZB00 and False.
	    -->
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
				<xsl:choose>
					<xsl:when test="$anLocalTesting ='YES'">
						<xsl:value-of
							select="'/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Buyer/LOOKUPTABLE.xml'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat('pd', ':', $p_ansupplierid, ':', $v_sysId, ':', 'Binary')"/>
					</xsl:otherwise>
				</xsl:choose>				
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
						<!--IG-41797 start-->
						<xsl:when
							test="$p_docType = 'PurchaseOrderChangeExportRequest' and $p_lookupName = 'ProcurementConditionType'"
							>ZB00</xsl:when>
						<!--IG-41797 end-->
                        <!--IG-34591: New doc type introduced as PaymentExportv2Request-->
						<xsl:when
							test= "( $p_docType = 'PaymentExportRequest' or $p_docType = 'PaymentExportv2Request' ) and $p_lookupName = 'WithholdingTaxMap'">
							<xsl:value-of select="upper-case($p_input)"/>
						</xsl:when>
                        <!--IG-34591: New doc type introduced as PaymentExportv2Request-->
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="FillDocType">
		<!-- Fill Document Type -->
		<!-- Fetch the document type maintian in Cross Reference Parameter -->
		<!-- Generic template most of transaction document type -->
		<!-- 
		Input :
		      p_doctype           : Current Addon Version (anAddOnCIVersion) Input from Iflow.
		      p_ordCategory       : Order Category such as ERP,INV,SCR,SDB,PR,FIINV,FIINV_IND
		      p_pd                : pd:AN02001565601:CROSSREFERENCE_Q8JCLNT002:Binary
		      p_itemCategory      : Input will be Yes for Framwork Order where itemcategory is B
		Output:
		      Document Type       : Depends on Document Type Maintian in Cross References parameter 
		                            such as"NB","RE","RA","KR","AR" and customer specific doc type
	    -->
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
	
	<xsl:template name="Check_SupportVersion">
		<!-- CIG Add On Version Check-->
		<!-- CIG Add On Version check was introduce from the time Addon Version was migrated to single version OOOOO -->
		<!-- Since in CIG there is a provision for supporting mulitple version of XSLT -->
		<!-- To support and avoid regression to older version, this template was introduce.-->
		<!-- 
		Input : 
		      p_sysversion            : Current Addon Version (anAddOnCIVersion) Input from Iflow.
		      p_suppversion           : Hard code value "06"
		Output:
		      Boolean Value           : True or False
	    -->
		<xsl:param name="p_sysversion"/>
		<xsl:param name="p_suppversion"/>
		<xsl:variable name="p_versioncheck">
			<xsl:value-of select="substring($p_sysversion, 9, 2)"/>
		</xsl:variable>		
		<xsl:if test="number($p_versioncheck) >= number($p_suppversion)">
			<xsl:value-of select="'true'"/>
		</xsl:if>		
	</xsl:template>
	
	<xsl:template name="FillMovType">
		<!-- Movement Type -->	
		<!-- The Movement type for reservation w.r.t accounting element which is maintain in Cross references parameter-->
		<!-- 
		Input :
		      p_doctype           : Document type e.g. ReservationAsyncExportRequest
		      p_acctDetail        : Accounting Element such as Cost Center, OrderID, Asset_no and wbs element.
		      p_pd                : pd:AN02001565601:CROSSREFERENCE_Q8JCLNT002:Binary
		Output:
		      Movement Type       : Returns values maintianed in cross references parameter otherwise the default values such as
		                            201 for Coster, 261 for Order ID, 241 for Asset No, 221 for Wbs element
	    -->
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
				<TEXT_FORM>X</TEXT_FORM>
				<!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
				<TEXT_LINE>
					<xsl:value-of select="$v_linestr1"/>
				</TEXT_LINE>
				<!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
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
					<!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
					<TEXT_FORM>
						<xsl:text disable-output-escaping="no">X</xsl:text>
					</TEXT_FORM>
					<!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
					<TEXT_LINE>
						<xsl:value-of select="$v_str1"/>
					</TEXT_LINE>
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
	
	<xsl:template name="ERPDateFormat">
		<!-- ERPdateFormat -->
		<!-- The template converts the P2P data format to ERP Specific date format-->
		<!-- 
		Input :
		      p_date              : P2P date formation YYYY-MM-DDTHH:MM:SSZ (2020-11-11T23:30:59Z)
		Output:
		      Date                : ERP Date format e.g. 2020-11-11
	    -->
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
	<xsl:template name="PrepareCrossref">
		<!-- Prepare the CrossRef path-->
		<!-- Generic template used accross document type PD entry path w.r.t ERP SystemID and AN ID-->
		<!-- 
		Input :
		      p_erpsysid          : SAP ERP system ID Example Q8JCLNT002
		      ansupplierid        : AN Sender ID
		Output:
		      Path                :  pd:AN02001565601:CROSSREFERENCE_Q8JCLNT002:Binary
	    -->
		<xsl:param name="p_erpsysid"/>
		<xsl:param name="p_ansupplierid"/>
		<!--constructing the crossreference string-->
		<xsl:variable name="v_crossref">
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
		<!-- Read Text ID  -->	
		<!-- The Movement type for reservation w.r.t accounting element which is maintain in Cross references parameter-->
		<!-- 
		Input :
		      p_doctype           : Document type e.g. PurchaseOrderRequest
		      p_pd                : pd:AN02001565601:CROSSREFERENCE_Q8JCLNT002:Binary
		      p_commenttype       : HeaderTextID , LineitemTextID and ServiceTextID
		Output:
		      Movement Type       : Text ID maintained in Cross Reference Parameter w.r.t transaction document type for headerTextID , LineitemTextID and ServiceTextID
		      						e.g. F01,F02..n
	    -->
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

	<xsl:template name="formatUTCDate">
		<!-- formatUTCDate -->
		<!-- The template converts the P2P data format to ERP Specific date format-->
		<!-- Consume following Date Format : Example "2018-11-22T18:35:01Z"
		Input :
		      p_UTCDate           : P2P UTC date formation YYYY-MM-DDTHH:MM:SSZ (2018-11-22T18:35:01Z)
		Output:
		      Date                : ERP UTC Date format e.g. 20201111183501
	    -->
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
	<!-- IG-37134 : Amount formatting based on currency -->
	<xsl:template name="formatAmount">
		<!-- formatAmount -->
		<!-- The template is intended to be used only for the non decimal currencies, eg JPY, VND, KRW-->
		<!-- Consume the amount
		Input :
		      p_amount           : Amount value
		Output:
		      Amount             : Amount in format of 000000000.00 (9,2)
		Examples:
		    Input                        Output
		 1. 90.00000                     90.00
		 2. 90                           90.00 
		 3. 90.00                        90.00
		 4. 123456789.00000              123456789.00
		 5. 123456789012345.00000        123456789.01
		 6. 1234567891.00                123456789.10
	    -->
		<xsl:param name="p_amount"/>
		<xsl:variable name="v_netVal">
			<xsl:choose>
				<xsl:when test="contains($p_amount, '.')">
					<xsl:value-of select="substring-before($p_amount, '.')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($p_amount,1,11)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="v_len" select="string-length($v_netVal)"/>
		<xsl:choose>
			<xsl:when test="$v_len > 10">
				<xsl:value-of select="concat(substring($v_netVal, 1, 9), '.', substring($v_netVal, 10,2))"/>
			</xsl:when>
			<xsl:when test="$v_len = 10">
				<xsl:value-of select="concat(substring($v_netVal, 1, 9), '.', substring($v_netVal, 10) , '0')"/>
			</xsl:when>
			<xsl:when test="$v_len > 0">
				<xsl:value-of select="format-number($v_netVal, '0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(0, '0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
