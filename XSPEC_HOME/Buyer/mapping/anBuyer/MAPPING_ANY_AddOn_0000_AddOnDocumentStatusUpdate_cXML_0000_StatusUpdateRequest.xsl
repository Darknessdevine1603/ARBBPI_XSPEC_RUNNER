<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:n0="http://sap.com/xi/ARBCIG1"
  exclude-result-prefixes="#all" version="2.0">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anERPTimeZone"/>
<!--  <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/> 
  <xsl:template match="n0:DocumentStatusUpdateRequest">
    <Combined>
      <Payload>
        <cXML>
          <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
          <xsl:attribute name="timestamp">
            <xsl:variable name="curDate">
              <xsl:value-of select="current-dateTime()"/>
            </xsl:variable>
            <xsl:value-of select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
          </xsl:attribute>
          <Header>
            <From>
              <xsl:call-template name="MultiERPTemplateOut">
                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
              </xsl:call-template>
              <Credential domain="NetworkID">
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
                  <xsl:value-of select="Vendor"/>
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
              <xsl:when test="$anEnvName='PROD'">
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
              <DocumentReference>
                <xsl:attribute name="payloadID">
                  <xsl:value-of select="ANPayloadID"/>
                </xsl:attribute>
              </DocumentReference>
              <!-- If Status is rejected, then code 423 is mapped. If status is accepted, then code 200 is mapped -->
              <Status>
                <xsl:attribute name="code">
                  <xsl:choose>
                    <xsl:when test="Status = 'REJECTED'">
                      <xsl:value-of select="'406'"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="'200'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="text">
                  <xsl:choose>
                    <xsl:when test="Status = 'REJECTED'">
                      <xsl:value-of select="'Not Acceptable'"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="'OK'"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <!-- Comment section is not required at status level if Document status has been populated -->
                <xsl:if test="IsDocumentStatusUpdate != 'true' or string-length(normalize-space(IsDocumentStatusUpdate)) = 0">                 
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="'en'"/>
                  </xsl:attribute>
                  <xsl:for-each select="Comment/Comment">
                    <!-- IG-33446 Added space while concatenating multiple comments-->
                    <xsl:choose>
                      <xsl:when test="position() = 1">
                         <xsl:value-of select="."/>
                      </xsl:when>
                      <xsl:otherwise>
                         <xsl:value-of select="concat(' ', .)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- IG-33446-->   
                  </xsl:for-each>
                </xsl:if>
              </Status>
              <xsl:choose>
                <xsl:when test="IsDocumentStatusUpdate != 'true' or string-length(normalize-space(IsDocumentStatusUpdate)) = 0">
                  <IntegrationStatus>
                    <xsl:attribute name="documentStatus">
                      <xsl:choose>
                        <xsl:when test="Status = 'ACCEPTED'">
                          <xsl:value-of select="'customerConfirmed'"/>
                        </xsl:when>
                        <xsl:when test="Status = 'REJECTED'">
                          <xsl:value-of select="'customerFailed'"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:attribute>
                    <IntegrationMessage>
                      <xsl:attribute name="isSuccessful">
                        <xsl:choose>
                          <xsl:when test="Status = 'ACCEPTED'">
                            <xsl:value-of select="'yes'"/>
                          </xsl:when>
                          <xsl:when test="Status = 'REJECTED'">
                            <xsl:value-of select="'no'"/>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:attribute name="type">
                        <xsl:value-of select="'AddOn'"/>
                      </xsl:attribute>
                    </IntegrationMessage>
                  </IntegrationStatus>
                </xsl:when>
                <xsl:otherwise>
                  <DocumentStatus>
                    <xsl:attribute name="type">
                      <xsl:choose>
                        <xsl:when test="Status = 'ACCEPTED'">
                          <xsl:value-of select="'approved'"/>
                        </xsl:when>
                        <xsl:when test="Status = 'REJECTED'">
                          <xsl:value-of select="'rejected'"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="DocumentNo">
                      <DocumentInfo>
                        <xsl:attribute name="documentID">
                          <xsl:value-of select="DocumentNo"/>
                        </xsl:attribute>
                        <xsl:attribute name="documentType">
                          <xsl:value-of select="DocumentType"/>
                        </xsl:attribute>
                        <xsl:if test="Date">
                          <xsl:attribute name="documentDate">
                            <xsl:value-of select="concat(Date, 'T', Time, $anERPTimeZone)"/>
                          </xsl:attribute>
                        </xsl:if>
                      </DocumentInfo>
                    </xsl:if>
                    <xsl:if test="Comment/Comment">
                      <Comments>
                        <xsl:value-of select="Comment/Comment"/>
                      </Comments>
                    </xsl:if>
                  </DocumentStatus>
                </xsl:otherwise>
              </xsl:choose>
              <!-- If ERP Document Number exist, then create Extrinsic node -->
              <xsl:if test="ERPDocumentNo != ''">
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'ERPDocumentNo'"/>
                  </xsl:attribute>
                  <xsl:value-of select="ERPDocumentNo"/>
                </Extrinsic>
              </xsl:if>
            </StatusUpdateRequest>
          </Request>
        </cXML>
      </Payload>
    </Combined>
  </xsl:template>
</xsl:stylesheet>
