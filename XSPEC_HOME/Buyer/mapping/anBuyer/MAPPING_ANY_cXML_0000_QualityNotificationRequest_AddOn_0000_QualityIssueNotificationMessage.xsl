<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAddOnCIVersion"/>                <!--CI-2361 AddOn Version -->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:template match="Combined">
        <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Prepare the CrossRef path-->
        <xsl:variable name="v_pd" select="'ParameterCrossreference.xml'"/>
        <xsl:variable name="v_pd">
           <xsl:call-template name="PrepareCrossref">
               <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
               <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
               <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
           </xsl:call-template>
       </xsl:variable>
        <!--Get the Language code-->
        <xsl:variable name="v_lang">
            <xsl:call-template name="FillDefaultLang">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_header"
            select="Payload/cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader"/>
        <xsl:variable name="v_item"
            select="Payload/cXML/Request/QualityNotificationRequest/QualityNotificationRequestItem"/>
        <xsl:variable name="v_payload_timestamp" select="Payload/cXML/@timestamp"/>                    <!-- CI-2361 Payload Timestamp -->
        <!-- CI-2361 Get CIG Addon Version-->
        <xsl:variable name="v_supportsp18onwards">
            <xsl:call-template name="Check_SupportVersion">
                <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
                <xsl:with-param name="p_suppversion" select="'18'"/>
            </xsl:call-template>            
        </xsl:variable>
        <xsl:if
            test="Payload/cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader">
            <n0:QualityIssueNotificationMessage>
                <MessageHeader>
                    <CreationDateTime>
                        <xsl:if test="(string-length(normalize-space($v_header/@requestDate)) > 0)">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_header/@requestDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:if>
                    </CreationDateTime>
                    <AribaNetworkPayloadID>
                        <xsl:value-of select="Payload/cXML/@payloadID"/>
                    </AribaNetworkPayloadID>
                    <AribaNetworkID>
                        <xsl:value-of select="$anReceiverID"/>
                    </AribaNetworkID>  
                    <RecipientParty>
                        <InternalID>
                            <xsl:value-of select="$v_sysid"/>
                        </InternalID>
                    </RecipientParty>
                </MessageHeader>
                <QualityIssueNotification>
                    <ActionCode>
                        <xsl:choose>
                            <xsl:when test="$v_header/@operation = 'new'">
                                <xsl:value-of select="'01'"/>
                            </xsl:when>
                            <xsl:when test="$v_header/@operation = 'update'">
                                <xsl:value-of select="'02'"/>
                            </xsl:when>
                        </xsl:choose>
                    </ActionCode>
                    <ListCompleteTransmissionIndicator>
                        <xsl:value-of select="'true'"/>
                    </ListCompleteTransmissionIndicator>
                    <ID>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_header/@externalRequestID)) > 0">
                                <xsl:value-of select="substring($v_header/@externalRequestID, 1, 12)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_header/@requestID"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ID>
                    <xsl:if test="string-length(normalize-space($v_header/@status)) > 0">
                        <StatusObject>
                            <SystemStatus>
                                <Code>
                                    <xsl:choose>
                                        <xsl:when test="$v_header/@status = 'new'">
                                            <xsl:value-of select="'I0068'"/>
                                        </xsl:when>
                                        <xsl:when test="$v_header/@status = 'in-process'">
                                            <xsl:value-of select="'I0070'"/>
                                        </xsl:when>
                                        <xsl:when test="$v_header/@status = 'completed'">
                                            <xsl:value-of select="'I0070'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </Code>
                                <ActiveIndicator>
                                    <xsl:value-of select="'true'"/>
                                </ActiveIndicator>
                            </SystemStatus>
                        </StatusObject>
                    </xsl:if>
                    <xsl:variable name="v_language">
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_header/QNNotes[1]/Description/@xml:lang)) > 0">
                                <xsl:value-of select="$v_header/QNNotes[1]/Description/@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="v_datetime">
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_header/QNNotes[1]/@createDate)) > 0">
                                <xsl:value-of select="$v_header/QNNotes[1]/@createDate"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <user>
                        <xsl:value-of select="$v_header/QNNotes[1]/@user"/>                        
                    </user>
                    <xsl:if test="(string-length(normalize-space($v_datetime)) > 0)">
                        <createDate>
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_datetime"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </createDate> 
                    </xsl:if>                     
                    <Description>
                        <xsl:attribute name="languageCode">
                            <xsl:value-of select="$v_language"/>
                        </xsl:attribute>
                        <xsl:for-each select="$v_header/QNNotes">
                            <xsl:value-of select="substring(Description/ShortName, 1, 40)"/>
                        </xsl:for-each>
                    </Description>
                    <DetailedText>
                        <xsl:attribute name="languageCode">
                            <xsl:value-of select="$v_language"/>
                        </xsl:attribute>
                        <xsl:for-each select="$v_header/QNNotes/Description">
                            <xsl:if test="../@createDate = //Payload/cXML/@timestamp"> <!-- IG-32227 -->
                                <xsl:value-of select="./text()"/>
                                <xsl:if test="normalize-space(.)">   
                                </xsl:if>    
                            </xsl:if>
                        </xsl:for-each>
                    </DetailedText>
                    <TypeCode>
                        <xsl:value-of select="substring($v_header/QNCode[@domain = 'type']/@code, 1, 2)"/>
                    </TypeCode>
                    <CodeGroup>
                        <xsl:value-of select="substring($v_header/QNCode[@domain = 'type']/@codeGroup, 1, 2)"/>
                    </CodeGroup>                    
                    <ImportanceCode>
                        <xsl:value-of select="$v_header/Priority/@level"/>
                    </ImportanceCode>
                    <IssueParentQualityIssueCategoryID>                        
                        <xsl:value-of select="substring($v_header/QNCode[@domain = 'subject']/@codeGroup, 1, 25)"/>                        
                    </IssueParentQualityIssueCategoryID>
                    <IssueQualityIssueCategoryID>
                        <xsl:value-of select="substring($v_header/QNCode[@domain = 'subject']/@code, 1, 25)"/>
                    </IssueQualityIssueCategoryID>
                    <ReportedDateTime>
                        <xsl:if test="(string-length(normalize-space($v_header/@requestDate)) > 0)">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_header/@requestDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:if>
                    </ReportedDateTime>
                    <createDate>
                        <xsl:if test="(string-length(normalize-space($v_header/@discoveryDate)) > 0)">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_header/@discoveryDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:if>
                    </createDate>                    
                    <RequestedProcessingPeriod>
                        <xsl:value-of select="$v_header/RequestedProcessingPeriod/Period"/>
                        <StartDateTime>
                            <xsl:if
                                test="(string-length(normalize-space($v_header/RequestedProcessingPeriod/Period/@startDate)) > 0)">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="$v_header/RequestedProcessingPeriod/Period/@startDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:if>
                        </StartDateTime>
                        <EndDateTime>
                            <xsl:if
                                test="(string-length(normalize-space($v_header/RequestedProcessingPeriod/Period/@endDate)) > 0)">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="$v_header/RequestedProcessingPeriod/Period/@endDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:if>
                        </EndDateTime>
                    </RequestedProcessingPeriod>
                    <MachineryMalfunctionPeriod>
                        <xsl:value-of select="$v_header/MalfunctionPeriod/Period"/>
                        <StartDateTime>
                            <xsl:if
                                test="(string-length(normalize-space($v_header/MalfunctionPeriod/Period/@startDate)) > 0)">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="$v_header/MalfunctionPeriod/Period/@startDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:if>
                        </StartDateTime>
                        <EndDateTime>
                            <xsl:if
                                test="(string-length(normalize-space($v_header/MalfunctionPeriod/Period/@endDate)) > 0)">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="$v_header/MalfunctionPeriod/Period/@endDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:if>
                        </EndDateTime>
                    </MachineryMalfunctionPeriod>
                    <xsl:if test="(string-length(normalize-space($v_header/ComplainQuantity/@quantity)) > 0)">
                        <ComplaintQuantity>
                            <xsl:attribute name="unitCode">
                                <xsl:if test="string-length(normalize-space($v_header/ComplainQuantity/UnitOfMeasure)) > 0">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="$v_header/ComplainQuantity/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:value-of select="$v_header/ComplainQuantity/@quantity"/>
                        </ComplaintQuantity>
                    </xsl:if>
                    <xsl:if test="(string-length(normalize-space($v_header/ReturnQuantity/@quantity)) > 0)">
                        <ReturnedQuantity>
                            <xsl:attribute name="unitCode">
                                <xsl:if test="string-length(normalize-space($v_header/ReturnQuantity/UnitOfMeasure)) > 0">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="$v_header/ReturnQuantity/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:value-of select="$v_header/ReturnQuantity/@quantity"/>
                        </ReturnedQuantity>
                    </xsl:if>                    
                    <ReturnDate>
                        <xsl:if test="(string-length(normalize-space($v_header/@returnDate)) > 0)">
                            <xsl:variable name="v_returnDate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_header/@returnDate"/>
                                <xsl:with-param name="p_timezone"
                                    select="$anERPTimeZone"/>
                            </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="substring($v_returnDate, 1, 10)"/>                                                                    
                        </xsl:if>
                    </ReturnDate>
                    <!-- CI-2361 Return Material Authorization Number Mapping -->
                    <xsl:if test="(string-length(normalize-space($v_header/@returnAuthorizationNumber)) > 0)">
                        <ReturnAuthorizationNumber>
                            <xsl:value-of select="$v_header/@returnAuthorizationNumber"/>
                        </ReturnAuthorizationNumber>
                    </xsl:if>
                    <ExternalQualityIssueNotificationReference>
                        <ID>
                            <xsl:value-of select="substring(string(upper-case($v_header/@requestID)), 1, 35)"/>
                        </ID>
                    </ExternalQualityIssueNotificationReference>

                    <xsl:for-each select="$v_header/QualityNotificationTask">
                        <Task>
                            <ActionCode>
                                <xsl:value-of select="'02'"/>
                            </ActionCode>
                            <TaskListCompleteTransmissionIndicator>
                                <xsl:value-of select="'true'"/>
                            </TaskListCompleteTransmissionIndicator>
                            <ID>
                                <xsl:value-of select="substring(@taskId, 1, 4)"/>
                            </ID>
                            <StatusObject>
                                <SystemStatus>
                                    <Code>
                                        <xsl:choose>
                                            <xsl:when test="@status = 'new'">
                                                <xsl:value-of select="'I0154'"/>
                                            </xsl:when>
                                            <xsl:when test="@status = 'in-process'">
                                                <xsl:value-of select="'I0155'"/>
                                            </xsl:when>
                                            <xsl:when test="@status = 'complete'">
                                                <xsl:value-of select="'I0155'"/>
                                            </xsl:when>
                                            <xsl:when test="@status = 'close'">
                                                <xsl:value-of select="'I0156'"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </Code>
                                    <ActiveIndicator>
                                        <xsl:value-of select="'true'"/>
                                    </ActiveIndicator>
                                </SystemStatus>
                            </StatusObject>
                            <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                            <xsl:variable name="v_language">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                        <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$v_lang"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <Description>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="$v_language"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                            </Description>
                            <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                            <!-- Else mapping will be concatenation of all QNNotes Description -->
                            <xsl:choose>
                                <xsl:when test="$v_supportsp18onwards = 'true'">
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="./text()"/> 
                                                </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('&#10;',./text())"/>
                                            </xsl:otherwise>
                                            </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>
                                </xsl:when>
                                <xsl:otherwise>
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes/Description">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="./text()"/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('&#10;',./text())"/>
                                                </xsl:otherwise>
                                            </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>
                                </xsl:otherwise>
                            </xsl:choose>
                            <PlannedProcessingPeriod>
                                <xsl:value-of select="Period"/>
                                <StartDateTime>
                                    <xsl:if test="(string-length(normalize-space(Period/@startDate)) > 0)">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="Period/@startDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </StartDateTime>
                                <EndDateTime>
                                    <xsl:if test="(string-length(normalize-space(Period/@endDate)) > 0)">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="Period/@endDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </EndDateTime>
                            </PlannedProcessingPeriod>
                            <AssignedToInternalID>
                                <xsl:choose>
                                    <xsl:when test="@processorType = 'supplier'">
                                        <xsl:value-of
                                            select="substring(../../../../Header/From/Credential[@domain = 'VendorID']/Identity, 1,32)"
                                        />
                                    </xsl:when>
                                    <xsl:when test="@processorType = 'customerUser'">
                                        <xsl:value-of select="substring(@processorId, 1,32)"/>
                                    </xsl:when>
                                </xsl:choose>
                            </AssignedToInternalID>
                            <AssignedToTypeCode>
                                <xsl:choose>
                                    <xsl:when test="@processorType = 'supplier'">
                                        <xsl:value-of select="'VN'"/>
                                    </xsl:when>
                                    <xsl:when test="@processorType = 'customerUser'">
                                        <xsl:value-of select="'VU'"/>
                                    </xsl:when>
                                </xsl:choose>
                            </AssignedToTypeCode>
                            <CompleterInternalID>
                                <xsl:value-of select="substring(@completedBy, 1, 32)"/>
                            </CompleterInternalID>
                            <CompletionDateTime>
                                <xsl:if test="(string-length(normalize-space(@completedDate)) > 0)">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@completedDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </CompletionDateTime>
                            <ParentQualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'task'">
                                    <xsl:value-of select="substring(QNCode/@codeGroup, 1, 25)"/>
                                </xsl:if>
                            </ParentQualityIssueCategoryID>
                            <QualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'task'">
                                    <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                </xsl:if>
                            </QualityIssueCategoryID>
                            <OrdinalNumberValue>
                                <xsl:value-of select="@taskId"/>
                            </OrdinalNumberValue>
                        </Task>
                    </xsl:for-each>
                    <xsl:for-each select="$v_header/QualityNotificationActivity">
                        <Activity>
                            <ActionCode>02</ActionCode>
                            <ActivityListCompleteTransmissionIndicator>true</ActivityListCompleteTransmissionIndicator>
                            <ID>
                                <xsl:value-of select="substring(@activityId, 1, 4)"/>
                            </ID>
                            <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                            <xsl:variable name="v_language">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                        <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$v_lang"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <Description>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="$v_language"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                            </Description>
                            <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                            <!-- Else mapping will be concatenation of all QNNotes Description -->
                            <xsl:choose>
                                <xsl:when test="$v_supportsp18onwards = 'true'">
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                        <xsl:choose>
                                            <xsl:when test="position() = 1">
                                                <xsl:value-of select="./text()"/> 
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('&#10;',./text())"/>
                                            </xsl:otherwise>
                                        </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>
                                </xsl:when>
                                <xsl:otherwise>
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes/Description">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="./text()"/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('&#10;',./text())"/>
                                                </xsl:otherwise>
                                            </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>                     
                                </xsl:otherwise>
                            </xsl:choose>
                            <ProcessingPeriod>
                                <xsl:value-of select="Period"/>
                                <StartDateTime>
                                    <xsl:if test="(string-length(normalize-space(Period/@startDate)) > 0)">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="Period/@startDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </StartDateTime>
                                <EndDateTime>
                                    <xsl:if test="(string-length(normalize-space(Period/@endDate)) > 0)">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="Period/@endDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </EndDateTime>
                            </ProcessingPeriod>
                            <ParentQualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'activity'">
                                    <xsl:value-of select="substring(QNCode/@codeGroup, 1, 25)"/>
                                </xsl:if>
                            </ParentQualityIssueCategoryID>
                            <QualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'activity'">
                                    <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                </xsl:if>
                            </QualityIssueCategoryID>
                            <OrdinalNumberValue>
                                <xsl:value-of select="@activityId"/>
                            </OrdinalNumberValue>
                        </Activity>
                    </xsl:for-each>
                    <VendorParty>
                        <ActionCode>01</ActionCode>
                        <InternalID>
                            <xsl:value-of
                                select="substring(Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity, 1, 32)"
                            />
                        </InternalID>
                    </VendorParty>
                    <xsl:if test="string-length(normalize-space($v_header/ItemInfo/ItemID/BuyerPartID)) > 0 or string-length($v_header/Contact[@role = 'buyerParty'][1]/@addressID) > 0">                                        
                        <Material>
                            <ActionCode>01</ActionCode>                              
                            <InternalID>
                                <xsl:if
                                    test="string-length(normalize-space($v_header/ItemInfo/ItemID/SupplierPartID/@revisionID)) > 0">
                                    <xsl:attribute name="schemeID">
                                        <xsl:value-of
                                            select="$v_header/ItemInfo/ItemID/SupplierPartID/@revisionID"
                                        />
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="substring($v_header/ItemInfo/ItemID/BuyerPartID, 1, 60)"/>
                            </InternalID>                            
                            <xsl:if test="(string-length($v_header/@serialNumber) > 0)">
                                <SerialID>
                                    <xsl:value-of select="$v_header/@serialNumber"/>
                                </SerialID>
                            </xsl:if>
                            <xsl:if test="string-length($v_header/Contact[@role = 'buyerParty'][1]/@addressID) > 0">
                                <PlantID>                                                                       
                                    <xsl:value-of select="substring($v_header/Contact[@role = 'buyerParty'][1]/@addressID, 1, 4)"/>                                                                       
                                </PlantID>
                            </xsl:if>
                            <SellerID>
                                <xsl:value-of select="substring($v_header/ItemInfo/ItemID/SupplierPartID, 1, 60)"/>
                            </SellerID>
                            <BatchID>
                                <xsl:value-of select="substring($v_header/Batch/BuyerBatchID, 1, 20)"/>
                            </BatchID>
                            <BatchSellerID>
                                <xsl:value-of select="substring($v_header/Batch/SupplierBatchID, 1, 40)"/>
                            </BatchSellerID>
                        </Material>                            
                    </xsl:if>
                    <xsl:for-each select="$v_header/ItemInfo/ReferenceDocumentInfo">
                    <xsl:if
                        test="DocumentInfo[@documentID != '' and @documentType = 'ShipNoticeDocument']">
                        <OutboundDeliveryReference>
                            <ActionCode>02</ActionCode>
                            <ID>
                                <xsl:if
                                    test="DocumentInfo/@documentType = 'ShipNoticeDocument'">
                                    <xsl:value-of
                                        select="substring(DocumentInfo/@documentID, 1, 35)"
                                    />
                                </xsl:if>
                            </ID>
                            <ItemID>
                                <xsl:if
                                    test="DocumentInfo/@documentType = 'ShipNoticeDocument'">
                                    <xsl:value-of
                                        select="substring(@lineNumber, 1, 5)"
                                    />
                                </xsl:if>
                            </ItemID>
                        </OutboundDeliveryReference>
                    </xsl:if>
                    </xsl:for-each>
                    <xsl:if
                        test="$v_header/ReferenceDocumentInfo/DocumentInfo[@documentID != '' and @documentType = 'PurchaseOrder']">
                        <PurchaseOrderReference>
                            <ActionCode>02</ActionCode>
                            <ID>
                                <xsl:if
                                    test="$v_header/ReferenceDocumentInfo/DocumentInfo/@documentType = 'PurchaseOrder'">
                                    <xsl:value-of
                                        select="substring($v_header/ReferenceDocumentInfo/DocumentInfo/@documentID,1 ,10)"
                                    />
                                </xsl:if>
                            </ID>
                            <ItemID>
                                <xsl:if
                                    test="$v_header/ReferenceDocumentInfo/DocumentInfo/@documentType = 'PurchaseOrder'">
                                    <xsl:value-of
                                        select="substring($v_header/ReferenceDocumentInfo/@lineNumber, 1, 5)"/>
                                </xsl:if>
                            </ItemID>
                        </PurchaseOrderReference>
                    </xsl:if>
                    <xsl:for-each select="$v_item">
                        <Item>
                            <ActionCode>02</ActionCode>
                            <ItemListCompleteTransmissionIndicator>true</ItemListCompleteTransmissionIndicator>
                            <ID>
                                <xsl:value-of select="substring(@defectId, 1, 4)"/>
                            </ID>
                            <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                            <xsl:variable name="v_language">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                        <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$v_lang"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <Description>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="$v_language"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                            </Description>
                            <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                            <!-- Else mapping will be concatenation of all QNNotes Description -->
                            <xsl:choose>
                                <xsl:when test="$v_supportsp18onwards = 'true'">
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="./text()"/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('&#10;',./text())"/>
                                                </xsl:otherwise>
                                            </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>
                                </xsl:when>
                                <xsl:otherwise>
                                    <DetailedText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:for-each select="QNNotes/Description">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="./text()"/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('&#10;',./text())"/>
                                                </xsl:otherwise>
                                            </xsl:choose>                            
                                        </xsl:for-each>
                                    </DetailedText>                           
                                </xsl:otherwise>
                            </xsl:choose>
                            <DefectTypeParentQualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'defect'">
                                    <xsl:value-of select="substring(QNCode/@codeGroup, 1, 25)"/>
                                </xsl:if>
                            </DefectTypeParentQualityIssueCategoryID>
                            <DefectTypeQualityIssueCategoryID>
                                <xsl:if test="QNCode/@domain = 'defect'">
                                    <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                </xsl:if>
                            </DefectTypeQualityIssueCategoryID>
                            <DefectNumberValue>
                                <xsl:value-of select="@defectCount"/>
                            </DefectNumberValue>
                            <OrdinalNumberValue>
                                <xsl:value-of select="@defectId"/>
                            </OrdinalNumberValue>
                            <!--CI-1626-->
                            <xsl:for-each select="AdditionalQNInfo">
                                <xsl:if test="string-length(normalize-space(ItemID/BuyerPartID)) > 0">
                                    <MaterialInternalID>
                                        <xsl:value-of
                                            select="substring(ItemID/BuyerPartID, 1, 60)"/>
                                    </MaterialInternalID>                                  
                                <xsl:if test="string-length(normalize-space(Batch/BuyerBatchID)) > 0">
                                    <Batch>												
                                        <BuyerBatchID>														
                                            <xsl:value-of
                                                select="substring(Batch/BuyerBatchID, 1, 20)"/>														
                                        </BuyerBatchID>												
                                    </Batch>
                                </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <!--CI-1626-->
                            <xsl:for-each select="QualityNotificationCause">
                                <Cause>
                                    <ActionCode>02</ActionCode>
                                    <ItemCauseListCompleteTransmissionIndicator>true</ItemCauseListCompleteTransmissionIndicator>
                                    <QualityIssueNotificationCauseID>
                                        <xsl:value-of select="substring(@causeId, 1, 4)"/>
                                    </QualityIssueNotificationCauseID>
                                    <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                                    <xsl:variable name="v_language">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                                <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_lang"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <Description>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                                    </Description>
                                    <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                                    <!-- Else mapping will be concatenation of all QNNotes Description -->
                                    <xsl:choose>
                                        <xsl:when test="$v_supportsp18onwards = 'true'">
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('&#10;',./text())"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('&#10;',./text())"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <ParentQualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'cause'">
                                            <xsl:value-of select="substring(QNCode/@codeGroup, 1, 25)"/>
                                        </xsl:if>
                                    </ParentQualityIssueCategoryID>
                                    <QualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'cause'">
                                            <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                        </xsl:if>
                                    </QualityIssueCategoryID>
                                    <OrdinalNumberValue>
                                        <xsl:value-of select="@causeId"/>
                                    </OrdinalNumberValue>
                                </Cause>
                            </xsl:for-each>
                            <xsl:for-each select="QualityNotificationTask">
                                <Task>
                                    <ActionCode>02</ActionCode>
                                    <ItemTaskListCompleteTransmissionIndicator>true</ItemTaskListCompleteTransmissionIndicator>
                                    <QualityIssueNotificationTaskID>
                                        <xsl:value-of select="substring(@taskId, 1, 4)"/>
                                    </QualityIssueNotificationTaskID>
                                    <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                                    <xsl:variable name="v_language">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                                <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_lang"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <Description>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                                    </Description>
                                    <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                                    <!-- Else mapping will be concatenation of all QNNotes Description -->
                                    <xsl:choose>
                                        <xsl:when test="$v_supportsp18onwards = 'true'">
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('&#10;',./text())"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('&#10;',./text())"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <StatusObject>
                                        <SystemStatus>
                                            <Code>
                                                <xsl:choose>
                                                  <xsl:when test="@status = 'new'">
                                                      <xsl:value-of select="'I0154'"/>
                                                  </xsl:when>
                                                  <xsl:when test="@status = 'in-process'">
                                                      <xsl:value-of select="'I0155'"/>
                                                  </xsl:when>
                                                  <xsl:when test="@status = 'complete'">
                                                      <xsl:value-of select="'I0155'"/>
                                                  </xsl:when>
                                                  <xsl:when test="@status = 'close'">
                                                      <xsl:value-of select="'I0156'"/>
                                                  </xsl:when>  
                                                </xsl:choose>
                                            </Code>
                                            <ActiveIndicator>
                                                <xsl:value-of select="'true'"/></ActiveIndicator>
                                        </SystemStatus>
                                    </StatusObject>
                                    <PlannedProcessingPeriod>
                                        <xsl:value-of select="Period"/>
                                        <StartDateTime>
                                            <xsl:if test="(string-length(normalize-space(Period/@startDate)) > 0)">
                                                <xsl:call-template name="ERPDateTime">
                                                  <xsl:with-param name="p_date"
                                                  select="Period/@startDate"/>
                                                  <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </StartDateTime>
                                        <EndDateTime>
                                            <xsl:if test="(string-length(normalize-space(Period/@endDate)) > 0)">
                                                <xsl:call-template name="ERPDateTime">
                                                  <xsl:with-param name="p_date"
                                                  select="Period/@endDate"/>
                                                  <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </EndDateTime>
                                    </PlannedProcessingPeriod>
                                    <AssignedToInternalID>
                                        <xsl:choose>
                                            <xsl:when test="@processorType = 'supplier'">
                                                <xsl:value-of
                                                    select="substring(../../../../Header/From/Credential[@domain = 'VendorID']/Identity, 1 ,32)"
                                                />
                                            </xsl:when>
                                            <xsl:when test="@processorType = 'customerUser'">
                                                <xsl:value-of select="substring(@processorId, 1, 32)"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </AssignedToInternalID>
                                    <AssignedToTypeCode>
                                        <xsl:choose>
                                            <xsl:when test="@processorType = 'supplier'">
                                                <xsl:value-of select="'VN'"/>
                                            </xsl:when>
                                            <xsl:when test="@processorType = 'customerUser'">
                                                <xsl:value-of select="'VU'"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </AssignedToTypeCode>
                                    <CompleterInternalID>
                                        <xsl:value-of select="substring(@completedBy, 1, 10)"/>
                                    </CompleterInternalID>
                                    <CompletionDateTime>
                                        <xsl:if test="(string-length(normalize-space(@completedDate)) > 0)">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                  select="@completedDate"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </CompletionDateTime>
                                    <ParentQualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'task'">
                                            <xsl:value-of select="substring(QNCode/@codeGroup, 1 , 25)"/>
                                        </xsl:if>
                                    </ParentQualityIssueCategoryID>
                                    <QualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'task'">
                                            <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                        </xsl:if>
                                    </QualityIssueCategoryID>
                                    <OrdinalNumberValue>
                                        <xsl:value-of select="@taskId"/>
                                    </OrdinalNumberValue>
                                </Task>
                            </xsl:for-each>
                            <xsl:for-each select="QualityNotificationActivity">
                                <Activity>
                                    <ActionCode>02</ActionCode>
                                    <temActivityListCompleteTransmissionIndicator>
                                        <xsl:value-of select="'true'"/>
                                    </temActivityListCompleteTransmissionIndicator>
                                    <QualityIssueNotificationActivityID>
                                        <xsl:value-of select="substring(@activityId, 1,4)"/>
                                    </QualityIssueNotificationActivityID>
                                    <!-- CI-2361 Decription,DetailedText mapping based on QNNotes -->
                                    <xsl:variable name="v_language">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(QNNotes[1]/Description/@xml:lang)) > 0">
                                                <xsl:value-of select="QNNotes[1]/Description/@xml:lang"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_lang"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <Description>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_language"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="substring(QNNotes[1]/Description/ShortName[1], 1, 40)"/>
                                    </Description>
                                    <!-- CI-2361 If AddOn Version is >= 18 mapping will be based on Payload Timestamp matching against QNNotes Timestamp-->
                                    <!-- Else mapping will be concatenation of all QNNotes Description -->
                                    <xsl:choose>
                                        <xsl:when test="$v_supportsp18onwards = 'true'">
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes[@createDate = $v_payload_timestamp]/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="concat('&#10;',./text())"/>
                                                    </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <DetailedText>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_language"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="QNNotes/Description">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="./text()"/> 
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('&#10;',./text())"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                            
                                                </xsl:for-each>
                                            </DetailedText>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <ProcessingPeriod>
                                        <xsl:value-of select="Period"/>
                                        <StartDateTime>
                                            <xsl:if test="(string-length(normalize-space(Period/@startDate)) > 0)">
                                                <xsl:call-template name="ERPDateTime">
                                                  <xsl:with-param name="p_date"
                                                  select="Period/@startDate"/>
                                                  <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </StartDateTime>
                                        <EndDateTime>
                                            <xsl:if test="(string-length(normalize-space(Period/@endDate)) > 0)">
                                                <xsl:call-template name="ERPDateTime">
                                                  <xsl:with-param name="p_date"
                                                  select="Period/@endDate"/>
                                                  <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </EndDateTime>
                                    </ProcessingPeriod>
                                    <ParentQualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'activity'">
                                            <xsl:value-of select="substring(QNCode/@codeGroup, 1,25)"/>
                                        </xsl:if>
                                    </ParentQualityIssueCategoryID>
                                    <QualityIssueCategoryID>
                                        <xsl:if test="QNCode/@domain = 'activity'">
                                            <xsl:value-of select="substring(QNCode/@code, 1, 25)"/>
                                        </xsl:if>
                                    </QualityIssueCategoryID>
                                    <OrdinalNumberValue>
                                        <xsl:value-of select="@activityId"/>
                                    </OrdinalNumberValue>
                                </Activity>
                            </xsl:for-each>
                        </Item>
                    </xsl:for-each>
                    <!-- CI-2361 URL Attachment -->
                    <xsl:if test="$v_header/QNNotes[@createDate = $v_payload_timestamp]/Attachment/URL[not(contains(.,'cid:'))]">
                        <URLAttachment>
                            <xsl:for-each select="$v_header/QNNotes[@createDate = $v_payload_timestamp]/Attachment/URL[not(contains(.,'cid:'))]">
                                <Item>
                                    <URL>
                                        <xsl:value-of select="."/>
                                    </URL>
                                    <xsl:if test="string-length(normalize-space(@name)) > 0">
                                    <URLDescription>
                                        <xsl:value-of select="@name"/>
                                    </URLDescription>
                                    </xsl:if>
                                </Item>
                            </xsl:for-each>
                        </URLAttachment>
                    </xsl:if>
                </QualityIssueNotification>
                <xsl:call-template name="InboundAttach"/>
            </n0:QualityIssueNotificationMessage>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
