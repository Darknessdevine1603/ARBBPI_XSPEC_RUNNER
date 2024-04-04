<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="anEnvName"/>
    <xsl:param name="anEventType"/>
    <xsl:param name="anErrorCode"/>
    <xsl:param name="anErrorDescription"/>
    <xsl:param name="anErrorXPath"/>
    <xsl:param name="anCorrelationID"/>
    <xsl:param name="anDocReferenceID"/>
    <xsl:param name="anMessageID"/> 
    <xsl:param name="anAlternateReceiverID"/>
    <xsl:param name="anAlternateSenderID"/>
    <xsl:param name="anDateTime"/>
    <xsl:param name="anIflowName"/>
    <xsl:param name="anICNValue"/> 
	<xsl:param name="releaseID" select="'9.2'"/>
    
    <!--xsl:variable name="SURStatus" select="document('SURStatusCodes.xml')"/-->
    <xsl:variable name="SURStatus" select="document('pd:HCIOWNERPID:LOOKUP_SURStatus:Binary')"/>
    
    <xsl:template match="/">
        <ConfirmBOD>
			<xsl:attribute name="releaseID">
				<xsl:value-of select="$releaseID"/>
			</xsl:attribute>
            <ApplicationArea>
                <Sender>
                    <LogicalID>
                        <xsl:value-of select="$anAlternateSenderID"/>
                    </LogicalID>
                    <ComponentID>StatusUpdateRequest</ComponentID>					
                </Sender>
                <CreationDateTime>                  
					<xsl:variable name="dateNow" select="current-dateTime()"/>
					<xsl:variable name="date2" select="format-dateTime($dateNow, '[Y]-[M01]-[D01]')"/>
					<xsl:variable name="date3" select="format-dateTime($dateNow, '[H01]:[m01]:[s01]')"/>	
					<xsl:variable name="date4" select="format-dateTime($dateNow, '[Z]')"/>	
					<xsl:value-of select="concat($date2,'T',$date3, $date4)"/>
                </CreationDateTime>
                <BODID>
                    <xsl:value-of select="$anICNValue"/>
                </BODID>
                <UserArea>
                    <DUNSID schemeID="ReceiverKey">
                        <xsl:value-of select="$anAlternateReceiverID"/>
                    </DUNSID>
                </UserArea>
            </ApplicationArea>
            <DataArea>
                <Confirm>
                    <OriginalApplicationArea>
                        <Sender>
                            <LogicalID>
                                <xsl:value-of select="$anAlternateReceiverID"/>
                            </LogicalID>
                        </Sender>
                        <CreationDateTime>
                            <xsl:value-of select="$anDateTime"/>
                        </CreationDateTime>
                        <BODID>
                            <xsl:value-of select="$anMessageID"/>
                        </BODID>
                        <UserArea>
                            <DUNSID>
                                <xsl:value-of select="$anAlternateSenderID"/>
                            </DUNSID>
                        </UserArea>
                    </OriginalApplicationArea>
                    <ResponseCriteria>
                        
                        <ResponseExpression>
                            <xsl:attribute name="actionCode">
                                <xsl:value-of select="concat($SURStatus/SURStatusLookup/SURStatus[SupplierFormat='OAGIS'][cXMLCode=$anErrorCode]/SupplierCode, '')"/>
                            </xsl:attribute>
                        </ResponseExpression>
                    </ResponseCriteria>
                </Confirm>
                <BOD>
                    <xsl:choose>
                        <xsl:when test="starts-with($anErrorCode, '20')">
                            <BODSuccessMessage>
                                <NounSuccessMessage>
                                    <ProcessMessage>
                                        <Description>
                                            <xsl:value-of select="$anErrorDescription"/>
                                        </Description>
                                    </ProcessMessage>
                                </NounSuccessMessage>
                            </BODSuccessMessage>
                        </xsl:when>
                        <xsl:otherwise>
                            <BODFailureMessage>
                                <ErrorProcessMessage>
                                    <Description>
                                        <xsl:value-of select="$anErrorDescription"/>
                                    </Description>
                                </ErrorProcessMessage>
                            </BODFailureMessage>
                        </xsl:otherwise>
                    </xsl:choose>
                </BOD>
            </DataArea>
        </ConfirmBOD>
    </xsl:template>
</xsl:stylesheet>