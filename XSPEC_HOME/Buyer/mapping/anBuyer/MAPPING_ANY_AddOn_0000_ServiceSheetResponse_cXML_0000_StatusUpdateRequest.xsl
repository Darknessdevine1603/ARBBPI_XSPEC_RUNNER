<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:n0="http://sap.com/xi/ARBCIG1"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <!--<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
  <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anERPTimeZone"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anTargetDocumentType"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <!--  PD path-->
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
    </xsl:call-template>
  </xsl:variable>
  <!--  Default lang-->
  <xsl:variable name="v_lang">
    <xsl:call-template name="FillDefaultLang">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="n0:ServiceEntrySheetResponse">
    <Combined>
      <Payload>
        <cXML>
          <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
          <xsl:attribute name="timestamp">
            <xsl:value-of
              select="concat(substring(string(current-date()), 1, 10), 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"
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
                  <xsl:value-of select="'VendorID'"/>
                </xsl:attribute>
                <Identity>
                  <xsl:value-of select="Record/LIFNR"/>
                </Identity>
              </Credential>
            </To>
            <Sender>
              <Credential domain="NetworkID">
                <Identity>
                  <xsl:value-of select="$anProviderANID"/>
                </Identity>
              </Credential>
              <UserAgent>
                <xsl:value-of select="'Ariba Supplier'"/>
              </UserAgent>
            </Sender>
          </Header>
          <Request>
            <xsl:choose>
              <xsl:when test="$anEnvName = 'PROD'">
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
            <StatusUpdateRequest>
              <Status>
                <!-- Set the code to 200, if an Entrysheet was created, else 423 -->
                <xsl:attribute name="code">
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space(Record/ERPEntrySheetNo)) > 0">200</xsl:when>
                    <xsl:otherwise>423</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="text">
                  <xsl:value-of select="'textOK'"/>
                </xsl:attribute>
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$v_lang"/>
                </xsl:attribute>
              </Status>
              <DocumentStatus>
                <xsl:attribute name="type">
                  <xsl:value-of select="Record/DocumentStatus"/>
                </xsl:attribute>
                <xsl:if test="Record/EntrySheetNo">
                  <DocumentInfo>
                    <xsl:attribute name="documentID">
                      <xsl:value-of select="Record/EntrySheetNo"/>
                    </xsl:attribute>
                    <xsl:attribute name="documentType">
                      <xsl:value-of select="'ServiceEntryRequest'"/>
                    </xsl:attribute>
                    <xsl:if test="string-length(normalize-space(Record/DocumentDate)) > 0">
                      <xsl:variable name="v_documentDate">
                        <xsl:value-of select='translate(substring(Record/DocumentDate, 1, 10), "-","")'/>
                      </xsl:variable>
                      <xsl:variable name="v_documentTime">
                        <xsl:value-of select='translate(substring(Record/DocumentTime, 1, 8), ":","")'/>
                      </xsl:variable>              
                      <xsl:attribute name="documentDate">
                        <xsl:call-template name="ANDateTime">
                          <xsl:with-param name="p_date" select="$v_documentDate"/>
                          <xsl:with-param name="p_time" select="$v_documentTime"/>
                          <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>                          
                        </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                  </DocumentInfo>
                </xsl:if>
                <xsl:if test="AribaComment/Item[not(ItemNumber)]">
                  <Comments>
                    <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                      <xsl:with-param name="p_aribaComment"
                        select="AribaComment"/>
                      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                      <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>                                                       
                  </Comments>
                </xsl:if>
              </DocumentStatus>
              <Extrinsic>
                <xsl:attribute name="name">
                  <xsl:value-of select="'ERP_ENTRYSHEET'"/>
                </xsl:attribute>
                <xsl:value-of select="Record/ERPEntrySheetNo"/>
              </Extrinsic>
            </StatusUpdateRequest>
          </Request>
        </cXML>
      </Payload>      
    </Combined>
  </xsl:template>
</xsl:stylesheet>
