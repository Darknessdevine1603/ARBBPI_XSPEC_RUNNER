<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="FGSOW">
        <!-- Map purchase order details to Fieldglass as Statement of Work -->
        <!-- input  p_header_path    :  PO header data
			        p_item_path      :  PO item data
			        p_from_identity  :  Buyer AN ID
             output                  :  SOW elements	-->
        <xsl:param name="p_header_path"/>
        <xsl:param name="p_item_path"/>
        <xsl:param name="p_from_identity"/>
        <!--	 CI-1802 {		variable for accounting info-->
        <xsl:param name="p_acc_info"/>
        <!--	* }CI-1802		-->
        <IsMasterSOW>No</IsMasterSOW>
        <SOWExternalRef>
            <xsl:value-of select="$p_header_path/@orderID"/>
        </SOWExternalRef>
        <!--        IG-40183 make available for SOW Revision-->
            <PONumber>
                <xsl:value-of select="$p_header_path/@orderID"/>
            </PONumber>  
        <!--        -->
        <CreatorUsername>
            <xsl:value-of select="$p_from_identity"/>
        </CreatorUsername>
        <!--This is applicable for only SOWRevision-->
        <xsl:if test="normalize-space($p_header_path/@type) = 'update'">
            <SOWBuyerRef>
                <xsl:value-of select="$p_header_path/@orderID"/>
            </SOWBuyerRef>
        </xsl:if>
        <Status>Submit</Status>
        <!--This is applicable for only SOW-->
        <xsl:if test="normalize-space($p_header_path/@type) = 'new'">
            <SubmitDate>
                <xsl:if test="string-length(normalize-space($p_header_path/@orderDate)) > 0">
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="p_datetimestr" select="$p_header_path/@orderDate"/>
                    </xsl:call-template>
                </xsl:if>
            </SubmitDate>
        </xsl:if>
        <OwnerUsername>
            <xsl:value-of select="$p_from_identity"/>
        </OwnerUsername>
        <sowCoordinatorUserNames/>
        <!--        IG-40183 make available for SOW Revision-->
            <Currency>
                <xsl:value-of select="$p_header_path/Total/Money/@currency"/>
            </Currency>
        <!--        -->
        <!--This is applicable for only SOW-->
        <xsl:if test="normalize-space($p_header_path/@type) = 'new'">
            <AdditionalCurrency/>
        </xsl:if>
        <!--        IG-40183 make available for SOW Revision-->
            <Classification>AribaNetworkClassification</Classification>
        <!--        -->
        <!--This is applicable for only SOW-->
        <xsl:if test="normalize-space($p_header_path/@type) = 'new'">
            <NonBillable>No</NonBillable>
            </xsl:if>
        <!--        IG-40183 make available for SOW Revision-->
            <Source>Template</Source>
            <TemplateName>FGSOWTemplate</TemplateName>
        <!--        -->
        <!--        IG-40183 make available for SOW Revision-->
            <xsl:if
                test="string-length(normalize-space(($p_item_path/MasterAgreementIDInfo/@agreementID[normalize-space()])[1])) > 0">
                <MasterSOWExternalRef>
                    <xsl:value-of
                        select="($p_item_path/MasterAgreementIDInfo/@agreementID[normalize-space()])[1]"
                    />
                </MasterSOWExternalRef>
            </xsl:if>       
        <!--        IG-40183 make available for SOW Revision-->
            <SupplierCode>
                <xsl:value-of
                    select="Payload/cXML/Header/To/Credential[translate(@domain, 'NETWORKID', 'networkid') = 'networkid'][1]/Identity"
                />
            </SupplierCode>
        <AddtionalSupplier/>
            <Name>
                <xsl:value-of select="$p_header_path/@orderID"/>
            </Name>
            <Description>
                <xsl:value-of select="'4R2 Purchase Order'"/>
            </Description>
            <!--			* }CI-1802			-->
            <!--Delivery Start Date-->
            <StartDate>
                <xsl:if
                    test="string-length(normalize-space(min($p_item_path/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate/xs:string(.)))) > 0">
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="p_datetimestr"
                            select="min($p_item_path/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate/xs:string(.))"
                        />
                    </xsl:call-template>
                </xsl:if>
            </StartDate>
        <!-- -->
        <!--Latest End date will be marked as the End date-->
        <EndDate>
            <xsl:if
                test="string-length(normalize-space(max($p_item_path/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate/xs:string(.)))) > 0">
                <xsl:variable name="v_service_enddate"> </xsl:variable>
                <xsl:call-template name="formatdate">
                    <xsl:with-param name="p_datetimestr"
                        select="max($p_item_path/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate/xs:string(.))"
                    />
                </xsl:call-template>
            </xsl:if>
        </EndDate>
        <!-- Plant-->
        <Site>
            <xsl:choose>
                <xsl:when
                    test="string-length(normalize-space($p_header_path/ShipTo/Address/@addressID)) > 0">
                    <xsl:value-of select="$p_header_path/ShipTo/Address/@addressID"/>
                </xsl:when>
                <xsl:when
                    test="string-length(normalize-space($p_item_path[1]/ShipTo/Address/@addressID)) > 0">
                    <xsl:value-of select="$p_item_path[1]/ShipTo/Address/@addressID"/>
                </xsl:when>
            </xsl:choose>
        </Site>
        <ApCode/>
        <WorkLocation>
            <xsl:choose>
                <xsl:when
                    test="string-length(normalize-space($p_header_path/ShipTo/Address/@addressID)) > 0">
                    <xsl:value-of select="$p_header_path/ShipTo/Address/@addressID"/>
                </xsl:when>
                <xsl:when
                    test="string-length(normalize-space($p_item_path[1]/ShipTo/Address/@addressID)) > 0">
                    <xsl:value-of select="$p_item_path[1]/ShipTo/Address/@addressID"/>
                </xsl:when>
            </xsl:choose>
        </WorkLocation>
        <!-- Purchase Organisation-->
        <BusinessUnitCode>
            <xsl:value-of
                select="$p_header_path/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
            />
        </BusinessUnitCode>
        <!--Company Code-->
        <xsl:if
            test="string-length(normalize-space($p_header_path/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier)) > 0">
            <LegalEntity>
                <xsl:value-of
                    select="$p_header_path/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
                />
            </LegalEntity>
        </xsl:if>
        <!--Header Comments-->
        <!--Since S4 can map multiple comments differentiated by type but this occurs only once in the target, concatenate the comments and map it to the target-->
        <CommentsToSupplier>
            <xsl:for-each select="$p_header_path/Comments">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(@type)) > 0">
                                <xsl:value-of select="concat(@type, ':', .)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(@type)) > 0">
                                <xsl:value-of select="concat(' ', @type, ':', .)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('&#10;', .)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </CommentsToSupplier>
        <!--This is applicable for only SOW-->
        <xsl:if test="normalize-space($p_header_path/@type) = 'new'">
            <DefinedBy>Both</DefinedBy>
        </xsl:if>
        <Clauses>No</Clauses>
        <!--			* }CI-2260-->
        <!--mapping change for <Event> and <Fee>-->
        <Characteristic>
            <Schedule>No</Schedule>
            <Event>Yes</Event>
            <Fee>No</Fee>
            <TeamMember>Yes</TeamMember>
            <ManagementEvent>No</ManagementEvent>
        </Characteristic>
        <!--        IG-40183 make available for SOW Revision-->
            <MaximumBudgetEnteredBySupplier/>
        <!-- -->
        <TaskCode>Billable Hours</TaskCode>
        <Rules>
            <AutoRespondPayTerms>Yes</AutoRespondPayTerms>
            <SkipCollaborationPayTerms>Yes</SkipCollaborationPayTerms>
            <xsl:if test="normalize-space($p_header_path/@type) = 'update'">
                <SupplierCannotModifyScheduleAmountsPriorToInvoicing/>
                <SupplierCanDecreaseScheduleAmountsPriorToInvoicing/>
                <SupplierCanIncreaseScheduleAmountsPriorToInvoicing/>
                <SupplierCannotModifyEventAmountsWhenMarkingAsComplete/>
                <SupplierCanDecreaseEventAmountsWhenMarkingAsComplete/>
                <SupplierCanIncreaseEventAmountsWhenMarkingAsComplete/>
            </xsl:if>
        </Rules>
        <Characteristics>
            <TrackTimeSheets/>
            <TimeSheetType>Standard</TimeSheetType>
            <TimeSheetFrequency/>
            <UnitOfMeasure>Hour</UnitOfMeasure>
            <HoursPerDay/>
            <HoursPerWeek/>
            <!--This is applicable for only SOW-->
            <xsl:if test="normalize-space($p_header_path/@type) = 'new'">
                <RateLookupName/>
            </xsl:if>
            <GiveWorkersAccessToAllTaskCodesForClients/>
            <AllowWorkerToSubmitTimeSheet/>
            <GiveWorkersAccessToAllExpenseCodesForTheClients/>
            <AllowInvoicingFromApprovedTimeSheets/>
            <AllowInvoicingFromApprovedExpenseSheets/>
            <IssueWarningIfHoursPerDayAreExceededOnTimeSheet/>
            <AllowTimeCaptureInHundredthsOfHours/>
            <AllowPerDiem/>
            <EstimatedExpenses/>
            <EstimatedAdditionalSpend/>
            <!--			* }CI-2260-->
            <!--All line item mappings, Cost center mappings and CustomField mapping, which were mapped in Fee
            will be moved to HierarchyEvents, which will cover the mappings for Hierarchy and Non-Hierarchy POs-->
            <HierarchyEvents>
                <EventHierarchyName/>
                <EventCustomLookUp/>
                <UseUserProvidedSequenceNumber>Yes</UseUserProvidedSequenceNumber>
                <!-- variable: check, if it is a material item-->
                <xsl:for-each select="$p_item_path">
                    <xsl:variable name="v_material">
                        <xsl:if test="string-length(normalize-space(ItemDetail)) > 0">
                            <xsl:value-of select="'X'"/>
                        </xsl:if>
                    </xsl:variable>
                    <!-- variable: check, if it is a parent item-->
                    <xsl:variable name="v_composite">
                        <xsl:if test="boolean(@itemType = 'composite')">
                            <xsl:value-of select="'true'"/>
                        </xsl:if>
                    </xsl:variable>
                    <!-- variable: pass parameter to deeper hierarchical level-->
                    <xsl:variable name="v_child_item_path" select="$p_item_path"/>
                    <!-- Check all items without Parentlinenumber; find Non-Hierarchy items and 1. level items -->
                    <xsl:if test="not(@parentLineNumber)">
                        <HierarchyEvent>
                            <xsl:if test="$v_composite != 'true'">
                                <ProductType>
                                    <xsl:choose>
                                        <xsl:when test="$v_material = 'X'">
                                            <xsl:value-of select="'MATERIAL'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'SERVICE'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </ProductType>
                            </xsl:if>
                            <xsl:if test="$v_composite != 'true'">
                                <ItemCategory>
                                    <xsl:choose>
                                        <xsl:when test="
                                                ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                                or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)
                                                or ((string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0)">
                                            <!--This is for Extended Limit Lean service-->
                                            <xsl:value-of select="'LIMIT'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'STANDARD'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </ItemCategory>
                            </xsl:if>
                            <!--			* }CI-2260-->
                            <!--This is for Extended Limit Lean service, where the contract is known-->
                            <xsl:if test="$v_composite != 'true'">
                                <EventCustomLookUp>
                                    <xsl:if
                                        test="string-length(normalize-space(MasterAgreementIDInfo/@agreementID)) > 0">
                                        <xsl:if test="
                                                ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                                or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)
                                                or ((string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0)">
                                            <xsl:value-of select="'CONTRACTS'"/>
                                        </xsl:if>
                                    </xsl:if>
                                </EventCustomLookUp>
                            </xsl:if>
                            <Name>
                                <xsl:if
                                    test="string-length(normalize-space(BlanketItemDetail/Description[1])) > 0">
                                    <xsl:value-of select="BlanketItemDetail/Description[1]"/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(ItemDetail/Description[1])) > 0">
                                    <xsl:value-of select="ItemDetail/Description[1]"/>
                                </xsl:if>
                            </Name>
                            <xsl:if
                                test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'FG.SOWnumber'])) > 0">
                                <FGInternalRef>
                                    <xsl:value-of
                                        select="BlanketItemDetail/Extrinsic[@name = 'FG.SOWnumber']"
                                    />
                                </FGInternalRef>
                            </xsl:if>
                            <!--			* }IG-38921-->
                            <!--Concat PO Number with lineitemnumber to make it unique for FG-->
                            <ExternalLineItemRef>
                                <xsl:value-of
                                    select="concat($p_header_path/@orderID, '|', @lineNumber)"/>
                            </ExternalLineItemRef>
                            <!--			end-->
                            <xsl:if
                                test="string-length(normalize-space($p_header_path/@orderID)) > 0">
                                <PONumber>
                                    <xsl:value-of select="$p_header_path/@orderID"/>
                                </PONumber>
                            </xsl:if>
                            <!--			* }CI-2696-->
                            <!--Hierarchy Numbers from s/4H-->
                            <BuyerDefinedSequenceNumber>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'hierarchyLineNumber'])) > 0">
                                        <xsl:value-of
                                            select="BlanketItemDetail/Extrinsic[@name = 'hierarchyLineNumber']"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="string-length(normalize-space(ItemDetail/Extrinsic[@name = 'hierarchyLineNumber'])) > 0">
                                        <xsl:value-of
                                            select="ItemDetail/Extrinsic[@name = 'hierarchyLineNumber']"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@lineNumber"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </BuyerDefinedSequenceNumber>
                            <xsl:if test="string-length(normalize-space(@parentLineNumber)) > 0">
                                <!--			* }IG-38921-->
                                <!--Concat PO Number with parentlineitemnumber to make it unique for FG-->
                                <ParentExternalLineItemRef>
                                    <xsl:value-of
                                        select="concat($p_header_path/@orderID, '|', @parentLineNumber)"/>
                                </ParentExternalLineItemRef>
                                <!--			end-->
                            </xsl:if>
                            <!--						* }CI-1802-->
                            <!--This is for Extended Limit Lean service-->
                            <!--			* }CI-2696-->
                            <!--If it is a Limit item, then send empty units, unittype and rate-->
                            <xsl:if test="$v_composite != 'true'">
                                <xsl:choose>
                                    <xsl:when test="
                                            ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                            or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)">
                                        <Units/>
                                        <UnitType/>
                                        <Rate/>
                                    </xsl:when>
                                    <xsl:when
                                        test="(string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0">
                                        <!--This is for Extended Limit Lean service-->
                                        <Units/>
                                        <UnitType/>
                                        <Rate/>
                                    </xsl:when>
                                    <xsl:when test="$v_material = 'X'">
                                        <Units>
                                            <xsl:value-of select="@quantity"/>
                                        </Units>
                                        <UnitType>
                                            <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                        </UnitType>
                                        <Rate>
                                            <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                        </Rate>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!--This is for Standard Lean service-->
                                        <Units>
                                            <xsl:value-of select="@quantity"/>
                                        </Units>
                                        <UnitType>
                                            <xsl:value-of select="BlanketItemDetail/UnitOfMeasure"/>
                                        </UnitType>
                                        <Rate>
                                            <xsl:value-of select="BlanketItemDetail/UnitPrice/Money"
                                            />
                                        </Rate>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <!--			* }CI-2260-->
                            <!--Expected Amounts for Limit lines only-->
                            <xsl:if test="$v_composite != 'true'">
                                <xsl:choose>
                                    <xsl:when test="
                                            ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                            or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)">
                                        <!--This is for Extended Limit Lean service-->
                                        <Amount>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="(string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0">
                                                  <xsl:value-of
                                                  select="BlanketItemDetail/ExpectedLimit/Money"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="(string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0">
                                                  <xsl:value-of
                                                  select="BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money"
                                                  />
                                                </xsl:when>
                                            </xsl:choose>
                                        </Amount>
                                    </xsl:when>
                                    <xsl:when
                                        test="(string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0">
                                        <Amount>
                                            <xsl:value-of select="ItemDetail/ExpectedLimit/Money"/>
                                        </Amount>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                            <!--			* }CI-2260-->
                            <!--Tolerance percentage for standard items, it will come only for Lean services from S/4H-->
                            <xsl:if test="$v_composite != 'true'">
                                <xsl:if
                                    test="string-length(normalize-space(ControlKeys/SESInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)) > 0">
                                    <TolerancePercent>
                                        <xsl:value-of
                                            select="ControlKeys/SESInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent"
                                        />
                                    </TolerancePercent>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="$v_composite != 'true'">
                                <CustomFields>
                                    <xsl:if
                                        test="string-length(normalize-space(ItemID/BuyerPartID))">
                                        <CustomField>
                                            <Name>ProductMaster ID</Name>
                                            <Value>
                                                <xsl:value-of select="ItemID/BuyerPartID"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(@lineNumber)) > 0">
                                        <CustomField>
                                            <Name>POLineItem</Name>
                                            <Value>
                                                <xsl:value-of select="@lineNumber"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(ShipTo/Address/@addressID)) > 0">
                                        <CustomField>
                                            <Name>Site</Name>
                                            <Value>
                                                <xsl:value-of select="ShipTo/Address/@addressID"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate)) > 0">
                                        <CustomField>
                                            <Name>POLineItem Start Date</Name>
                                            <Value>
                                                <xsl:value-of
                                                  select="SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate"
                                                />
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate)) > 0">
                                        <CustomField>
                                            <Name>POLineItem End Date</Name>
                                            <Value>
                                                <xsl:value-of
                                                  select="SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate"
                                                />
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(@agreementItemNumber)) > 0">
                                        <CustomField>
                                            <Name>POLineItem Contract ID</Name>
                                            <Value>
                                                <xsl:value-of select="@agreementItemNumber"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(MasterAgreementIDInfo/@agreementID)) > 0">
                                        <CustomField>
                                            <Name>Contract ID</Name>
                                            <Value>
                                                <xsl:value-of
                                                  select="MasterAgreementIDInfo/@agreementID"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(ItemID/BuyerPartID)) > 0">
                                        <CustomField>
                                            <Name>Product Master</Name>
                                            <Value>
                                                <xsl:value-of select="ItemID/BuyerPartID"/>
                                            </Value>
                                        </CustomField>
                                    </xsl:if>
                                </CustomFields>
                            </xsl:if>
                            <xsl:if test="$v_composite = 'true'">
                                <ChildHierarchyEvents>
                                    <xsl:call-template name="findAllChildren">
                                        <xsl:with-param name="p_linenumber" select="@lineNumber"/>
                                        <xsl:with-param name="p_level" select="'1'"/>
                                        <xsl:with-param name="p_items" select="$v_child_item_path"/>
                                        <xsl:with-param name="p_acc_info" select="$p_acc_info"/>
                                        <xsl:with-param name="p_header_path" select="$p_header_path"
                                        />
                                    </xsl:call-template>
                                </ChildHierarchyEvents>
                            </xsl:if>
                            <!--						* CI-1802 { Start of inclusion to pass accounting info						-->
                            <xsl:if test="$v_composite != 'true'">
                                <xsl:variable name="v_linenum">
                                    <xsl:value-of select="@lineNumber"/>
                                </xsl:variable>
                                <xsl:variable name="v_multiassign">
                                    <xsl:value-of
                                        select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/MultipleAcctAssgmtDistribution"
                                    />
                                </xsl:variable>
                                <xsl:variable name="v_AccAssCat">
                                    <xsl:value-of
                                        select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/AccountAssignmentCategory"
                                    />
                                </xsl:variable>
                                <xsl:if test="$v_composite != 'true'">
                                    <CostCenters>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$v_AccAssCat = 'K' or $v_AccAssCat = 'P'">
                                                <xsl:for-each
                                                  select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/to_AccountAssignment/A_PurOrdAccountAssignmentType">
                                                  <!--								Write code to check if a item is material type -->
                                                  <!--								(Also need to check PD entries for Costcentercoce and glcode if account assignment type is other that K,P) Not required-->
                                                  <!--								Update: IG-34998: Remove CostCenterCode when $v_AccAssCat= 'F', insert F/ FU into otherwise part-->
                                                  <CostCenter>
                                                  <CostCenterCode>
                                                  <xsl:choose>
                                                  <xsl:when test="$v_AccAssCat = 'K'">
                                                  <xsl:value-of select="CostCenter"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'P'">
                                                  <xsl:value-of select="WBSElement"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </CostCenterCode>
                                                  <xsl:choose>
                                                  <xsl:when test="position() = 1">
                                                  <PrimaryCostCenter>Yes</PrimaryCostCenter>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <PrimaryCostCenter>No</PrimaryCostCenter>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <GeneralLedgers>
                                                  <GeneralLedger>
                                                  <GeneralLedgerCode>
                                                  <xsl:value-of select="GLAccount"/>
                                                  </GeneralLedgerCode>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="string-length(normalize-space($v_multiassign)) > 0">
                                                  <Allocation>
                                                  <xsl:value-of
                                                  select="MultipleAcctAssgmtDistrPercent"/>
                                                  </Allocation>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <Allocation>100</Allocation>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <AllocationBy>Percentage</AllocationBy>
                                                  </GeneralLedger>
                                                  </GeneralLedgers>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="string-length(normalize-space($v_multiassign)) > 0">
                                                  <Allocation>
                                                  <xsl:value-of
                                                  select="MultipleAcctAssgmtDistrPercent"/>
                                                  </Allocation>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <Allocation>100</Allocation>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <AllocationBy>Percentage</AllocationBy>
                                                  </CostCenter>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <CostCenter>
                                                  <CostCenterCode>
                                                  <xsl:choose>
                                                  <xsl:when test="$v_AccAssCat = 'A'">
                                                  <xsl:value-of select="'AU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'B'">
                                                  <xsl:value-of select="'BU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'D'">
                                                  <xsl:value-of select="'DU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'E'">
                                                  <xsl:value-of select="'EU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'F'">
                                                  <xsl:value-of select="'FU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'G'">
                                                  <xsl:value-of select="'GU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'H'">
                                                  <xsl:value-of select="'HU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'M'">
                                                  <xsl:value-of select="'MU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'Q'">
                                                  <xsl:value-of select="'QU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'S'">
                                                  <xsl:value-of select="'SU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'T'">
                                                  <xsl:value-of select="'TU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'U'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'N'">
                                                  <xsl:value-of select="'NU'"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:if test="$v_material = 'X'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </CostCenterCode>
                                                  <PrimaryCostCenter>Yes</PrimaryCostCenter>
                                                  <GeneralLedgers>
                                                  <GeneralLedger>
                                                  <GeneralLedgerCode>
                                                  <xsl:choose>
                                                  <xsl:when test="$v_AccAssCat = 'A'">
                                                  <xsl:value-of select="'AU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'B'">
                                                  <xsl:value-of select="'BU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'D'">
                                                  <xsl:value-of select="'DU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'E'">
                                                  <xsl:value-of select="'EU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'F'">
                                                  <xsl:value-of select="'FU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'G'">
                                                  <xsl:value-of select="'GU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'H'">
                                                  <xsl:value-of select="'HU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'M'">
                                                  <xsl:value-of select="'MU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'Q'">
                                                  <xsl:value-of select="'QU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'S'">
                                                  <xsl:value-of select="'SU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'T'">
                                                  <xsl:value-of select="'TU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'U'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'N'">
                                                  <xsl:value-of select="'NU'"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:if test="$v_material = 'X'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </GeneralLedgerCode>
                                                  <Allocation>100</Allocation>
                                                  <AllocationBy>Percentage</AllocationBy>
                                                  </GeneralLedger>
                                                  </GeneralLedgers>
                                                  <Allocation>100</Allocation>
                                                  <AllocationBy>Percentage</AllocationBy>
                                                </CostCenter>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </CostCenters>
                                </xsl:if>
                            </xsl:if>
                        </HierarchyEvent>
                    </xsl:if>
                </xsl:for-each>
            </HierarchyEvents>
        </Characteristics>
        <!--        IG-40183 make available for SOW Revision-->
            <RateCodes>
                <RateCode>
                    <ModificationType>A</ModificationType>
                    <RateCategory>ST</RateCategory>
                    <UnitOfMeasure>Hour</UnitOfMeasure>
                    <!--			* }CI-2260-->
                    <!--					change: concat with currency-->
                    <Code>
                        <xsl:value-of
                            select="concat($p_header_path//Total/Money/@currency, '_', 'AN_RATE')"/>
                    </Code>
                    <CommittedSpendFlag>No</CommittedSpendFlag>
                    <Rate>1</Rate>
                </RateCode>
            </RateCodes>
            <TeamMemberRoles>
                <TeamMemberRole>
                    <Role>Worker</Role>
                    <Site>
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space($p_header_path/ShipTo/Address/@addressID)) > 0">
                                <xsl:value-of select="$p_header_path/ShipTo/Address/@addressID"/>
                            </xsl:when>
                            <xsl:when
                                test="string-length(normalize-space($p_item_path[1]/ShipTo/Address/@addressID)) > 0">
                                <xsl:value-of select="$p_item_path[1]/ShipTo/Address/@addressID"/>
                            </xsl:when>
                        </xsl:choose>
                    </Site>
                    <PeriodWorked>0</PeriodWorked>
                    <NumberOfPositions>0</NumberOfPositions>
                    <RateCodes>
                        <RateCode>
                            <ModificationType>A</ModificationType>
                            <RateCategory>ST</RateCategory>
                            <UnitOfMeasure>Hour</UnitOfMeasure>
                            <!--			* }CI-2260-->
                            <!--					change: concat with currency-->
                            <Code>
                                <xsl:value-of
                                    select="concat($p_header_path//Total/Money/@currency, '_', 'AN_RATE')"
                                />
                            </Code>
                            <CommittedSpendFlag>No</CommittedSpendFlag>
                            <Rate>1</Rate>
                        </RateCode>
                    </RateCodes>
                </TeamMemberRole>
            </TeamMemberRoles>
        <!--        -->
        <CustomFields>
            <xsl:if test="string-length(normalize-space($p_header_path/@orderDate)) > 0">
                <CustomField>
                    <Name>Order Date</Name>
                    <Value>
                        <xsl:value-of select="$p_header_path/@orderDate"/>
                    </Value>
                </CustomField>
            </xsl:if>
            <!--*{CI-1802 map paylaod id to custom field-->
            <CustomField>
                <Name>SURRefID</Name>
                <Value>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </Value>
            </CustomField>
            <!--							* }CI-1802-->
        </CustomFields>
    </xsl:template>
    <!--			* }CI-2260-->
    <!--All line item mappings, Cost center mappings and CustomField mapping, which were mapped in Fee
            will be moved to HierarchyEvents, which will cover the mappings for Hierarchy and Non-Hierarchy POs-->
    <!--TEMPLATE	-->
    <xsl:template name="findAllChildren">
        <xsl:param name="p_linenumber"/>
        <xsl:param name="p_items"/>
        <xsl:param name="p_level"/>
        <xsl:param name="p_acc_info"/>
        <xsl:param name="p_header_path"/>

        <xsl:for-each select="$p_items[@parentLineNumber = $p_linenumber]">
            <xsl:variable name="v_composite">
                <xsl:if test="boolean(@itemType = 'composite')">
                    <xsl:value-of select="'true'"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="v_material">
                <xsl:if test="string-length(normalize-space(ItemDetail)) > 0">
                    <xsl:value-of select="'X'"/>
                </xsl:if>
            </xsl:variable>
            <HierarchyEvent>
                <xsl:if test="$v_composite != 'true'">
                    <ProductType>
                        <xsl:choose>
                            <xsl:when test="$v_material = 'X'">
                                <xsl:value-of select="'MATERIAL'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'SERVICE'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ProductType>
                </xsl:if>
                <xsl:if test="$v_composite != 'true'">
                    <ItemCategory>
                        <xsl:choose>
                            <xsl:when test="
                                    ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                    or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)
                                    or ((string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0)">
                                <!--This is for Extended Limit Lean service-->
                                <xsl:value-of select="'LIMIT'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'STANDARD'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ItemCategory>
                </xsl:if>
                <!--			* }CI-2260-->
                <!--This is for Extended Limit Lean service, where the contract is known-->
                <xsl:if test="$v_composite != 'true'">
                    <EventCustomLookUp>
                        <xsl:if
                            test="string-length(normalize-space(MasterAgreementIDInfo/@agreementID)) > 0">
                            <xsl:if test="
                                    ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                    or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)
                                    or ((string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0)">
                                <xsl:value-of select="'CONTRACTS'"/>
                            </xsl:if>
                        </xsl:if>
                    </EventCustomLookUp>
                </xsl:if>
                <Name>
                    <xsl:if
                        test="string-length(normalize-space(BlanketItemDetail/Description[1])) > 0">
                        <xsl:value-of select="BlanketItemDetail/Description[1]"/>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space(ItemDetail/Description[1])) > 0">
                        <xsl:value-of select="ItemDetail/Description[1]"/>
                    </xsl:if>
                </Name>
                <xsl:if
                    test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'FG.SOWnumber'])) > 0">
                    <FGInternalRef>
                        <xsl:value-of select="BlanketItemDetail/Extrinsic[@name = 'FG.SOWnumber']"/>
                    </FGInternalRef>
                </xsl:if>
                <!--			* }IG-38921-->
                <!--Concat PO Number with lineitemnumber to make it unique for FG-->
                <ExternalLineItemRef>
                    <xsl:value-of
                        select="concat($p_header_path/@orderID, '|', @lineNumber)"/>
                </ExternalLineItemRef>
                <!--			end-->
                <xsl:if test="string-length(normalize-space($p_header_path/@orderID)) > 0">
                    <PONumber>
                        <xsl:value-of select="$p_header_path/@orderID"/>
                    </PONumber>
                </xsl:if>
                <!--			* }CI-2696-->
                <!--Hierarchy Numbers from s/4H-->
                <BuyerDefinedSequenceNumber>
                    <xsl:choose>
                        <xsl:when
                            test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'hierarchyLineNumber'])) > 0">
                            <xsl:value-of
                                select="BlanketItemDetail/Extrinsic[@name = 'hierarchyLineNumber']"
                            />
                        </xsl:when>
                        <xsl:when
                            test="string-length(normalize-space(ItemDetail/Extrinsic[@name = 'hierarchyLineNumber'])) > 0">
                            <xsl:value-of
                                select="ItemDetail/Extrinsic[@name = 'hierarchyLineNumber']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@lineNumber"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </BuyerDefinedSequenceNumber>
                <xsl:if test="string-length(normalize-space(@parentLineNumber)) > 0">
                    <!--			* }IG-38921-->
                    <!--Concat PO Number with parentlineitemnumber to make it unique for FG-->
                    <ParentExternalLineItemRef>
                        <xsl:value-of
                            select="concat($p_header_path/@orderID, '|', @parentLineNumber)"/>
                    </ParentExternalLineItemRef>
                    <!--			end-->
                </xsl:if>
                <!--						* }CI-1802-->
                <!--This is for Extended Limit Lean service-->
                <!--			* }CI-2696-->
                <!--If it is a Limit item, then send empty units, unittype and rate-->
                <xsl:if test="$v_composite != 'true'">
                    <xsl:choose>
                        <xsl:when test="
                                ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)">
                            <Units/>
                            <UnitType/>
                            <Rate/>
                        </xsl:when>
                        <xsl:when
                            test="(string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0">
                            <Units/>
                            <UnitType/>
                            <Rate/>
                        </xsl:when>
                        <xsl:when test="$v_material = 'X'">
                            <Units>
                                <xsl:value-of select="@quantity"/>
                            </Units>
                            <UnitType>
                                <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                            </UnitType>
                            <Rate>
                                <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                            </Rate>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--This is for Standard Lean service-->
                            <Units>
                                <xsl:value-of select="@quantity"/>
                            </Units>
                            <UnitType>
                                <xsl:value-of select="BlanketItemDetail/UnitOfMeasure"/>
                            </UnitType>
                            <Rate>
                                <xsl:value-of select="BlanketItemDetail/UnitPrice/Money"/>
                            </Rate>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <!--			* }CI-2260-->
                <!--Expected Amounts for Limit lines only-->
                <xsl:if test="$v_composite != 'true'">
                    <xsl:choose>
                        <xsl:when test="
                                ((string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0)
                                or ((string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0)">
                            <!--This is for Extended Limit Lean service-->
                            <Amount>
                                <xsl:choose>
                                    <xsl:when
                                        test="(string-length(normalize-space(BlanketItemDetail/ExpectedLimit))) > 0">
                                        <xsl:value-of select="BlanketItemDetail/ExpectedLimit/Money"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="(string-length(normalize-space(BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money))) > 0">
                                        <xsl:value-of
                                            select="BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </Amount>
                        </xsl:when>
                        <xsl:when
                            test="(string-length(normalize-space(ItemDetail/ExpectedLimit))) > 0">
                            <Amount>
                                <xsl:value-of select="ItemDetail/ExpectedLimit/Money"/>
                            </Amount>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <!--			* }CI-2260-->
                <!--Tolerance percentage for standard items, it will come only for Lean services from S/4H-->
                <xsl:if test="$v_composite != 'true'">
                    <xsl:if
                        test="string-length(normalize-space(ControlKeys/SESInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)) > 0">
                        <TolerancePercent>
                            <xsl:value-of
                                select="ControlKeys/SESInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent"
                            />
                        </TolerancePercent>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$v_composite != 'true'">
                    <CustomFields>
                        <xsl:if test="string-length(normalize-space(ItemID/BuyerPartID))">
                            <CustomField>
                                <Name>ProductMaster ID</Name>
                                <Value>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@lineNumber)) > 0">
                            <CustomField>
                                <Name>POLineItem</Name>
                                <Value>
                                    <xsl:value-of select="@lineNumber"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(ShipTo/Address/@addressID)) > 0">
                            <CustomField>
                                <Name>Site</Name>
                                <Value>
                                    <xsl:value-of select="ShipTo/Address/@addressID"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate)) > 0">
                            <CustomField>
                                <Name>POLineItem Start Date</Name>
                                <Value>
                                    <xsl:value-of
                                        select="SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate"
                                    />
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate)) > 0">
                            <CustomField>
                                <Name>POLineItem End Date</Name>
                                <Value>
                                    <xsl:value-of
                                        select="SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate"
                                    />
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@agreementItemNumber)) > 0">
                            <CustomField>
                                <Name>POLineItem Contract ID</Name>
                                <Value>
                                    <xsl:value-of select="@agreementItemNumber"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(MasterAgreementIDInfo/@agreementID)) > 0">
                            <CustomField>
                                <Name>Contract ID</Name>
                                <Value>
                                    <xsl:value-of select="MasterAgreementIDInfo/@agreementID"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(ItemID/BuyerPartID)) > 0">
                            <CustomField>
                                <Name>Product Master</Name>
                                <Value>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </Value>
                            </CustomField>
                        </xsl:if>
                    </CustomFields>
                </xsl:if>
                <xsl:if test="$v_composite = 'true'">
                    <ChildHierarchyEvents>
                        <xsl:call-template name="findAllChildren">
                            <xsl:with-param name="p_linenumber" select="./@lineNumber"/>
                            <xsl:with-param name="p_level" select="'0'"/>
                            <xsl:with-param name="p_items" select="$p_items"/>
                            <xsl:with-param name="p_acc_info" select="$p_acc_info"/>
                            <xsl:with-param name="p_header_path" select="$p_header_path"/>
                        </xsl:call-template>
                    </ChildHierarchyEvents>
                </xsl:if>
                <!--	AccountingInfo						-->
                <xsl:if test="$v_composite != 'true'">
                    <xsl:variable name="v_linenum">
                        <xsl:value-of select="@lineNumber"/>
                    </xsl:variable>
                    <xsl:variable name="v_multiassign">
                        <xsl:value-of
                            select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/MultipleAcctAssgmtDistribution"
                        />
                    </xsl:variable>
                    <xsl:variable name="v_AccAssCat">
                        <xsl:value-of
                            select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/AccountAssignmentCategory"
                        />
                    </xsl:variable>
                    <xsl:if test="$v_composite != 'true'">
                        <CostCenters>
                            <xsl:choose>
                                <xsl:when test="$v_AccAssCat = 'K' or $v_AccAssCat = 'P'">
                                    <xsl:for-each
                                        select="$p_acc_info/A_PurchaseOrderItem/A_PurchaseOrderItemType[PurchaseOrderItem = $v_linenum]/to_AccountAssignment/A_PurOrdAccountAssignmentType">
                                        <!--								Write code to check if a item is material type -->
                                        <!--								(Also need to check PD entries for Costcentercoce and glcode if account assignment type is other that K, P) Not required-->
                                        <!--								Update: IG-34998: Remove CostCenterCode when $v_AccAssCat= 'F', insert F/ FU into otherwise part-->
                                        <CostCenter>
                                            <CostCenterCode>
                                                <xsl:choose>
                                                  <xsl:when test="$v_AccAssCat = 'K'">
                                                  <xsl:value-of select="CostCenter"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'P'">
                                                  <xsl:value-of select="WBSElement"/>
                                                  </xsl:when>
                                                </xsl:choose>
                                            </CostCenterCode>
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                  <PrimaryCostCenter>Yes</PrimaryCostCenter>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <PrimaryCostCenter>No</PrimaryCostCenter>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <GeneralLedgers>
                                                <GeneralLedger>
                                                  <GeneralLedgerCode>
                                                  <xsl:value-of select="GLAccount"/>
                                                  </GeneralLedgerCode>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="string-length(normalize-space($v_multiassign)) > 0">
                                                  <Allocation>
                                                  <xsl:value-of
                                                  select="MultipleAcctAssgmtDistrPercent"/>
                                                  </Allocation>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <Allocation>100</Allocation>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <AllocationBy>Percentage</AllocationBy>
                                                </GeneralLedger>
                                            </GeneralLedgers>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="string-length(normalize-space($v_multiassign)) > 0">
                                                  <Allocation>
                                                  <xsl:value-of
                                                  select="MultipleAcctAssgmtDistrPercent"/>
                                                  </Allocation>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <Allocation>100</Allocation>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <AllocationBy>Percentage</AllocationBy>
                                        </CostCenter>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <CostCenter>
                                        <CostCenterCode>
                                            <xsl:choose>
                                                <xsl:when test="$v_AccAssCat = 'A'">
                                                  <xsl:value-of select="'AU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'B'">
                                                  <xsl:value-of select="'BU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'D'">
                                                  <xsl:value-of select="'DU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'E'">
                                                  <xsl:value-of select="'EU'"/>
                                                </xsl:when>
                                                <!-- IG-34998 -->
                                                <xsl:when test="$v_AccAssCat = 'F'">
                                                  <xsl:value-of select="'FU'"/>
                                                </xsl:when>
                                                <!-- IG-34998 -->
                                                <xsl:when test="$v_AccAssCat = 'G'">
                                                  <xsl:value-of select="'GU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'H'">
                                                  <xsl:value-of select="'HU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'M'">
                                                  <xsl:value-of select="'MU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'Q'">
                                                  <xsl:value-of select="'QU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'S'">
                                                  <xsl:value-of select="'SU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'T'">
                                                  <xsl:value-of select="'TU'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'U'">
                                                  <xsl:value-of select="'U'"/>
                                                </xsl:when>
                                                <xsl:when test="$v_AccAssCat = 'N'">
                                                  <xsl:value-of select="'NU'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:if test="$v_material = 'X'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </CostCenterCode>
                                        <PrimaryCostCenter>Yes</PrimaryCostCenter>
                                        <GeneralLedgers>
                                            <GeneralLedger>
                                                <GeneralLedgerCode>
                                                  <xsl:choose>
                                                  <xsl:when test="$v_AccAssCat = 'A'">
                                                  <xsl:value-of select="'AU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'B'">
                                                  <xsl:value-of select="'BU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'D'">
                                                  <xsl:value-of select="'DU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'E'">
                                                  <xsl:value-of select="'EU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'F'">
                                                  <xsl:value-of select="'FU'"/>
                                                  </xsl:when>
                                                  <!-- IG-34998 -->
                                                  <xsl:when test="$v_AccAssCat = 'G'">
                                                  <xsl:value-of select="'GU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'H'">
                                                  <xsl:value-of select="'HU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'M'">
                                                  <xsl:value-of select="'MU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'Q'">
                                                  <xsl:value-of select="'QU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'S'">
                                                  <xsl:value-of select="'SU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'T'">
                                                  <xsl:value-of select="'TU'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'U'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_AccAssCat = 'N'">
                                                  <xsl:value-of select="'NU'"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:if test="$v_material = 'X'">
                                                  <xsl:value-of select="'U'"/>
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </GeneralLedgerCode>
                                                <Allocation>100</Allocation>
                                                <AllocationBy>Percentage</AllocationBy>
                                            </GeneralLedger>
                                        </GeneralLedgers>
                                        <Allocation>100</Allocation>
                                        <AllocationBy>Percentage</AllocationBy>
                                    </CostCenter>
                                </xsl:otherwise>
                            </xsl:choose>
                        </CostCenters>
                    </xsl:if>
                </xsl:if>
            </HierarchyEvent>
        </xsl:for-each>
    </xsl:template>
    <!-- Map Hreader data like language, Number & Date formats to Fieldglass  
             output                  :  Header data	-->
    <xsl:template name="FGHeader">
        <Header>
            <Language>
                <xsl:value-of select="'English (United States)'"/>
            </Language>
            <NumberFormat>
                <xsl:value-of select="'#,##9.99 (Example: 1,234,567.99)'"/>
            </NumberFormat>
            <DateFormat>
                <xsl:value-of select="'MM/DD/YYYY'"/>
            </DateFormat>
        </Header>
    </xsl:template>
    <!--	Format Date Template-->
    <xsl:template name="formatdate">
        <xsl:param name="p_datetimestr"/>
        <xsl:variable name="mm">
            <xsl:value-of select="substring($p_datetimestr, 6, 2)"/>
        </xsl:variable>
        <xsl:variable name="dd">
            <xsl:value-of select="substring($p_datetimestr, 9, 2)"/>
        </xsl:variable>
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring($p_datetimestr, 1, 4)"/>
        </xsl:variable>
        <xsl:value-of select="concat($mm, '/', $dd, '/', $yyyy)"/>
    </xsl:template>
</xsl:stylesheet>
