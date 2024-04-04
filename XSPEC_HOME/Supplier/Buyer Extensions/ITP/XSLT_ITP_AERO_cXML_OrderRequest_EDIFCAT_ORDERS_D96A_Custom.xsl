<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
  <!-- For local testing -->

  <!--xsl:variable name="Lookup" select="document('LOOKUP_UN-EDIFACT_D96A.xml')"/>
	<xsl:include href="FORMAT_cXML_D96A_common.xsl"/-->
  <xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_UN-EDIFACT_D96A:Binary"/>

  <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>


  <xsl:template match="//source"/>
  <!-- Extension Start  -->
  <!-- Header Extrinsic -->
  <xsl:template match="//M_ORDERS/G_SG1[last()]">
    <xsl:copy-of select="."/>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'customerReferenceNo']) != ''">
      <G_SG1>
        <S_RFF>
          <C_C506>
            <D_1153>CR</D_1153>
            <D_1154>
              <xsl:value-of
                select="
                  substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name
                  = 'customerReferenceNo']), 1, 35)"
              />
            </D_1154>
          </C_C506>
        </S_RFF>
      </G_SG1>
    </xsl:if>

  </xsl:template>

  <xsl:template match="//M_ORDERS/G_SG25/S_DTM[last()]">
    <xsl:variable name="lineNumber" select="../S_LIN/D_1082"/>
    <xsl:copy-of select="."/>
    <xsl:choose>

      <xsl:when
        test="
          normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber =
          $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryDate']) != ''">
        <S_DTM>
          <C_C507>
            <D_2005>17</D_2005>
            <xsl:call-template name="formatDate">
              <xsl:with-param name="DocDate"
                select="
                  normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber =
                  $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryDate'])"
              />
            </xsl:call-template>
          </C_C507>
        </S_DTM>
      </xsl:when>
      <xsl:when
        test="
          normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber =
          $lineNumber]/BlanketItemDetail/Extrinsic[@name = 'deliveryDate']) != ''">
        <S_DTM>
          <C_C507>
            <D_2005>17</D_2005>
            <xsl:call-template name="formatDate">
              <xsl:with-param name="DocDate"
                select="
                  normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber =
                  $lineNumber]/BlanketItemDetail/Extrinsic[@name = 'deliveryDate'])"
              />
            </xsl:call-template>
          </C_C507>
        </S_DTM>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//M_ORDERS/G_SG25/G_SG26[last()]">
    <xsl:variable name="lineNumber" select="../S_LIN/D_1082"/>

    <xsl:copy-of select="."/>
    <xsl:choose>
      
    <xsl:when
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'lineOfBusiness']) != ''">
      <G_SG26>
        <S_CCI>
          <C_C240>
            <D_7037>
              <xsl:value-of
                select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'lineOfBusiness']), 1, 17)"
              />
            </D_7037>
            <D_7036>
              <xsl:value-of select="'LineOfBusiness'"/>
            </D_7036>
          </C_C240>
        </S_CCI>
      </G_SG26>
    </xsl:when>
      <xsl:when
        test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber =
        $lineNumber]/BlanketItemDetail/Extrinsic[@name = 'lineOfBusiness']) != ''">
        <G_SG26>
          <S_CCI>
            <C_C240>
              <D_7037>
                <xsl:value-of
                  select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber
                  = $lineNumber]/BlanketItemDetail/Extrinsic[@name = 'lineOfBusiness']), 1, 17)"
                />
              </D_7037>
              <D_7036>
                <xsl:value-of select="'LineOfBusiness'"/>
              </D_7036>
            </C_C240>
          </S_CCI>
        </G_SG26>
      </xsl:when>
    </xsl:choose>

  </xsl:template>


  <!-- Extension Ends -->
  <xsl:template match="//Combined">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:template>
  <xsl:template match="//target">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
