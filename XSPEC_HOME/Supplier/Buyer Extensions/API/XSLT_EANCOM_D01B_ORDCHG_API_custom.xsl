<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
  <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_EANCOM.xml')"/-->
  <!-- PD references -->
  <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_EANCOM_D01BEAN011:Binary')"/>
  <xsl:template match="//source"/>
  <!-- Extension Start  -->
  <xsl:template match="//M_ORDCHG/S_BGM">
    <S_BGM>
      <xsl:apply-templates select="C_C106 | C_C002"/>
      <xsl:choose>
        <xsl:when test="D_1225 = '3'">
          <D_1225>1</D_1225>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="D_1225"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="//OrderRequestHeader/ControlKeys/OCInstruction/@value = 'notAllowed'">
          <D_4343>NA</D_4343>
        </xsl:when>
        <xsl:when test="//OrderRequestHeader/ControlKeys/OCInstruction/@value = 'allowed'">
          <D_4343>AB</D_4343>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="D_4343"/>
        </xsl:otherwise>
      </xsl:choose>
    </S_BGM>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/S_FTX[D_4451 = 'SIN']">
    <xsl:choose>
      <xsl:when test="./following-sibling::S_FTX[D_4451 = 'SIN']"/>
      <xsl:otherwise>
        <xsl:if
          test="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType'] != ''">
          <xsl:variable name="transactiontype">
            <xsl:choose>
              <xsl:when
                test="replace(lower-case(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']), ' ', '') = 'standardpo'">
                <xsl:text>001</xsl:text>
              </xsl:when>
              <xsl:when
                test="replace(lower-case(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']), ' ', '') = 'discrepancypo'">
                <xsl:text>002</xsl:text>
              </xsl:when>
              <xsl:when
                test="replace(lower-case(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']), ' ', '') = 'returnpo'">
                <xsl:text>003</xsl:text>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="$transactiontype != ''">
            <S_FTX>
              <D_4451>ZZZ</D_4451>
              <C_C107>
                <D_4441>
                  <xsl:value-of select="$transactiontype"/>
                </D_4441>
              </C_C107>
              <C_C108>
                <D_4440>
                  <xsl:value-of
                    select="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']"
                  />
                </D_4440>
              </C_C108>
            </S_FTX>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/S_FTX[D_4451 = 'SIN']"/>
  <xsl:template match="//M_ORDCHG/G_SG27/S_LIN/D_1082">
    <D_1082>
      <xsl:value-of select="."/>
    </D_1082>
    <D_1229>110</D_1229>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/S_IMD">
    <xsl:choose>
      <xsl:when test="D_7077 = 'E'"/>
      <xsl:when test="D_7077 = 'F'">
        <S_IMD>
          <D_7077>
            <xsl:value-of select="'E'"/>
          </D_7077>
          <xsl:copy-of select="D_7077/following-sibling::*"/>
        </S_IMD>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/G_SG33/S_RFF/C_C506[D_1153 = 'ALQ']/D_1153">
    <D_1153>AKO</D_1153>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/S_FTX[D_4451 = 'ORI']"/>
  <xsl:template match="//M_ORDCHG/G_SG3/S_NAD">
    <xsl:variable name="role" select="D_3035"/>
    <xsl:variable name="cXMLRole"
      select="$Lookup/Lookups/Roles/Role[EANCOMCode = $role][1]/CXMLCode"/>
    <S_NAD>
      <xsl:copy-of select="D_3035"/>
      <xsl:copy-of select="C_C082"/>
      <xsl:copy-of select="C_C058"/>
      <xsl:choose>
        <xsl:when
          test="D_3035 = 'ST' and normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address[lower-case(@addressIDDomain) = 'buyerlocationid']/@addressID) != ''">
          <C_C080>
            <D_3036>
              <xsl:value-of
                select="normalize-space(substring(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address[lower-case(@addressIDDomain) = 'buyerlocationid']/@addressID, 1, 35))"
              />
            </D_3036>
            <xsl:variable name="STName"
              select="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Name)"/>
            <xsl:call-template name="NADSegName">
              <xsl:with-param name="partyName" select="$STName"/>
            </xsl:call-template>
          </C_C080>
        </xsl:when>
        <xsl:when
          test="(D_3035 = 'BY' and normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address[lower-case(@addressIDDomain) = 'buyerid']/@addressID) != '' and not(exists(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyer']/@addressID))) or (D_3035 = 'IV' and normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address[lower-case(@addressIDDomain) = 'buyerid']/@addressID) != '')">
          <C_C080>
            <D_3036>
              <xsl:value-of
                select="normalize-space(substring(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address[lower-case(@addressIDDomain) = 'buyerid']/@addressID, 1, 35))"
              />
            </D_3036>
            <xsl:variable name="BTName"
              select="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Name)"/>
            <xsl:call-template name="NADSegName">
              <xsl:with-param name="partyName" select="$BTName"/>
            </xsl:call-template>
          </C_C080>
        </xsl:when>
        <xsl:when
          test="$cXMLRole != '' and normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = $cXMLRole][lower-case(@addressIDDomain) = 'buyerid']/@addressID) != ''">
          <C_C080>
            <D_3036>
              <xsl:value-of
                select="normalize-space(substring(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = $cXMLRole][lower-case(@addressIDDomain) = 'buyerid']/@addressID, 1, 35))"
              />
            </D_3036>
            <xsl:variable name="CTName"
              select="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = $cXMLRole]/Name)"/>
            <xsl:call-template name="NADSegName">
              <xsl:with-param name="partyName" select="$CTName"/>
            </xsl:call-template>
          </C_C080>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="C_C080"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of
        select="D_3035/following-sibling::*[not(self::C_C082) and not(self::C_C058) and not(self::C_C080)]"
      />
    </S_NAD>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/G_SG38/S_MOA[C_C516/D_5025 = '124']">
    <S_MOA>
      <C_C516>
        <D_5025>369</D_5025>
        <xsl:copy-of select="C_C516/D_5025/following-sibling::*"/>
      </C_C516>
    </S_MOA>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/S_MOA[C_C516/D_5025 = '124']">
    <S_MOA>
      <C_C516>
        <D_5025>369</D_5025>
        <xsl:copy-of select="C_C516/D_5025/following-sibling::*"/>
      </C_C516>
    </S_MOA>
  </xsl:template>
  <xsl:template match="//M_ORDCHG/G_SG27/G_SG38[S_MOA/C_C516/D_5025 = '125']"/>
  <xsl:template name="NADSegName">
    <xsl:param name="partyName"/>
    <xsl:if test="$partyName != ''">
      <D_3036_2>
        <xsl:value-of select="normalize-space(substring($partyName, 1, 35))"/>
      </D_3036_2>
      <xsl:if test="normalize-space(substring($partyName, 36, 35)) != ''">
        <D_3036_3>
          <xsl:value-of select="normalize-space(substring($partyName, 36, 35))"/>
        </D_3036_3>
      </xsl:if>
      <xsl:if test="normalize-space(substring($partyName, 71, 35)) != ''">
        <D_3036_4>
          <xsl:value-of select="normalize-space(substring($partyName, 71, 35))"/>
        </D_3036_4>
      </xsl:if>
      <xsl:if test="normalize-space(substring($partyName, 106, 35)) != ''">
        <D_3036_5>
          <xsl:value-of select="normalize-space(substring($partyName, 106, 35))"/>
        </D_3036_5>
      </xsl:if>
    </xsl:if>
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
