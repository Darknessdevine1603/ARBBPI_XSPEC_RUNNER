<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="//source"/>
  <!-- Extension Start  -->
  <xsl:template match="//PurchaseOrderLine/Status">
    <xsl:variable name="linNum" select="../LineNumber"/>
    <xsl:copy-of select="."/>
    <xsl:if test="not(exists(../Item))">
      <xsl:if
        test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != '' or //OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
        <xsl:element name="Item">
          <xsl:element name="Classification">
            <xsl:element name="Codes">
              <xsl:element name="Code">
                <xsl:choose>
                  <xsl:when
                    test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
                    <xsl:value-of
                      select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'])"
                    />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'])"
                    />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//PurchaseOrderLine/Item/Classification[last()]">
    <xsl:variable name="linNum" select="../LineNumber"/>
    <xsl:copy-of select="."/>
    <xsl:if
      test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != '' or //OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
      <xsl:element name="Classification">
        <xsl:element name="Codes">
          <xsl:element name="Code">
            <xsl:choose>
              <xsl:when
                test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
                <xsl:value-of
                  select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'])"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'])"
                />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//PurchaseOrderLine/Item[not(exists(Classification))]">
    <xsl:variable name="linNum" select="../LineNumber"/>
    <xsl:element name="Item">
      <xsl:copy-of select="ItemID"/>
      <xsl:copy-of select="CustomerItemID"/>
      <xsl:copy-of select="ManufacturerItemID"/>
      <xsl:copy-of select="SupplierItemID"/>
      <xsl:copy-of select="UPCID"/>
      <xsl:copy-of select="EPCID"/>
      <xsl:copy-of select="ServiceIndicator"/>
      <xsl:copy-of select="Description"/>
      <xsl:copy-of select="Note"/>
      <xsl:if
        test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != '' or //OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
        <xsl:element name="Classification">
          <xsl:element name="Codes">
            <xsl:element name="Code">
              <xsl:choose>
                <xsl:when
                  test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'] != ''">
                  <xsl:value-of
                    select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Classification[lower-case(@domain) = 'not available'])"
                  />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Classification[lower-case(@domain) = 'not available'])"
                  />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="(node() | @*)[not(following-sibling::Classification)]"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="//PurchaseOrderLine/DocumentReference/Status[last()]">
    <xsl:variable name="linNum" select="../../LineNumber"/>
    <xsl:copy-of select="."/>
    <xsl:if
      test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Extrinsic[@name = 'MaximumUnplanned']/Money[@currency != ''] != ''">
      <xsl:element name="Status">
        <xsl:element name="Code">
          <xsl:attribute name="name">MaximumUnplannedAmount</xsl:attribute>
          <xsl:value-of
            select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Extrinsic[@name = 'MaximumUnplanned']/Money)"
          />
        </xsl:element>
        <xsl:element name="Description">
          <xsl:value-of
            select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Extrinsic[@name = 'MaximumUnplanned']/Money/@currency)"
          />
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if
      test="//OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Extrinsic[@name = 'isConfigurableItem'] != ''">
      <xsl:element name="Status">
        <xsl:element name="Code">
          <xsl:attribute name="name">isConfigurableItem</xsl:attribute>
          <xsl:value-of
            select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/ItemDetail/Extrinsic[@name = 'isConfigurableItem'])"
          />
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if
      test="//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Extrinsic[@name = 'extLineNumber'] != ''">
      <xsl:element name="Status">
        <xsl:element name="Code">
          <xsl:attribute name="name">extLineNumber</xsl:attribute>
          <xsl:value-of
            select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/BlanketItemDetail/Extrinsic[@name = 'extLineNumber'])"
          />
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if
      test="//OrderRequest/ItemOut[@lineNumber = $linNum]/SpendDetail/Extrinsic[@name = 'GenericServiceCategory']">
      <xsl:element name="Status">
        <xsl:element name="Code">
          <xsl:attribute name="name">GenericServiceCategory</xsl:attribute>
          <xsl:value-of
            select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $linNum]/SpendDetail/Extrinsic[@name = 'GenericServiceCategory'])"
          />
        </xsl:element>
      </xsl:element>
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
