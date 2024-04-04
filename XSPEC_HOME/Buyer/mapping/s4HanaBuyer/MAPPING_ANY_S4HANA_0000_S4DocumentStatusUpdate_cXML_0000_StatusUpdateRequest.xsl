<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBS4FND"
  exclude-result-prefixes="#all" version="2.0">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anSenderID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anEnvName"/>
<!--  <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
  <xsl:template match="n0:DocumentStatusUpdate">
    <cXML>
      <xsl:attribute name="payloadID">
        <xsl:value-of select="$anPayloadID"/>
      </xsl:attribute>
      <xsl:attribute name="timestamp">
        <xsl:variable name="v_curDate">
          <xsl:value-of select="current-dateTime()"/>
        </xsl:variable>
        <xsl:value-of select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"/>
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
              <xsl:value-of select="$anSenderID"/>
            </Identity>
          </Credential>
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
              <xsl:value-of select="DocStsUpdate/Supplier"/>
            </Identity>
          </Credential>
        </To>
        <Sender>
          <Credential>
            <xsl:attribute name="domain">
              <xsl:value-of select="'NetworkID'"/>
            </xsl:attribute>
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
          <DocumentReference>
            <xsl:attribute name="payloadID">
            <xsl:value-of select="DocStsUpdate/ANPayloadID"/>
            </xsl:attribute>
          </DocumentReference>
          <Status>
            <xsl:attribute name="code">
              <xsl:choose>
                <xsl:when test="DocStsUpdate/Status = 'REJECTED'">
                  <xsl:value-of select="'406'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'200'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="text">
              <xsl:choose>
                <xsl:when test="DocStsUpdate/Status = 'REJECTED'">
                  <xsl:value-of select="'Not Acceptable'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'OK'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <!-- Concat comments, if message is not successfull. If succesful just one coment will be sent from s4H. -->
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="'en'"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="DocStsUpdate/Status = 'REJECTED'">
                <xsl:for-each select="DocStsUpdate/Comment/Comment">
                  <xsl:choose>
                    <xsl:when test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="concat(' ', .)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="DocStsUpdate/Comment/Comment"/>
              </xsl:otherwise>
            </xsl:choose>
          </Status>
          <IntegrationStatus>
            <xsl:attribute name="documentStatus">
            <xsl:choose>
              <xsl:when test="DocStsUpdate/Status = 'ACCEPTED'">
                <xsl:value-of select="'deliverySuccessful'"/>
              </xsl:when>
              <xsl:when test="DocStsUpdate/Status = 'REJECTED'">
                <xsl:value-of select="'deliveryDelayed'"/>
              </xsl:when>
            </xsl:choose>
            </xsl:attribute>
            <IntegrationMessage>
              <xsl:attribute name="isSuccessful">
                <xsl:choose>
                  <xsl:when test="DocStsUpdate/Status = 'ACCEPTED'">
                    <xsl:value-of select="'yes'"/>
                  </xsl:when>
                  <xsl:when test="DocStsUpdate/Status = 'REJECTED'">
                    <xsl:value-of select="'no'"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="type">
                <xsl:value-of select="'S4HANA'"/>
              </xsl:attribute>
            </IntegrationMessage>
          </IntegrationStatus>
          <!-- If S4 Document Number exists, then create Extrinsic node -->
          <xsl:if test="DocStsUpdate/S4DocumentNo != ''">
            <Extrinsic>
              <xsl:attribute name="name">
              <xsl:value-of select="'ERPDocumentNo'"/>
              </xsl:attribute>
              <xsl:value-of select="DocStsUpdate/S4DocumentNo"/>
            </Extrinsic>
          </xsl:if>
        </StatusUpdateRequest>
      </Request>
    </cXML>
  </xsl:template>
</xsl:stylesheet>
