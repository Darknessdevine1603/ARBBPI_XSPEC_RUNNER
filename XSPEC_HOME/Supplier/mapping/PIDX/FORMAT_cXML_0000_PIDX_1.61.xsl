<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pidx="http://www.pidx.org/schemas/v1.61" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/2001/XMLSchema" version="2.0">
  <!-- Functions -->
  <xsl:template name="formatAmount">
    <xsl:param name="amount"/>
    <xsl:value-of select="normalize-space(replace($amount, ',', ''))"/>
  </xsl:template>
  <xsl:template name="breakText">
    <xsl:param name="text"/>
    <xsl:call-template name="tokenizeCompleteWord">
      <xsl:with-param name="pText" select="$text"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="tokenizeCompleteWord">
    <xsl:param name="pText"/>
    <xsl:choose>
      <xsl:when test="string-length($pText) &lt; 950">
        <xsl:value-of select="$pText"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="textBefore">
          <xsl:value-of
            select="substring($pText, 1, 950 + string-length(substring-before(substring($pText, 951), ' ')))"
          />
        </xsl:variable>
        <xsl:value-of select="$textBefore"/>
        <xsl:text>                </xsl:text>
        <xsl:call-template name="tokenizeCompleteWord">
          <xsl:with-param name="pText">
            <xsl:value-of select="substring-after($pText, $textBefore)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- IG-26030 Map Instructions -->
  <xsl:template name="MapInstructions">
    <xsl:param name="keys"/>
    <xsl:if test="normalize-space($keys/OCInstruction/@value) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCValue</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/@value)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCLowerQtyTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCUpperQtyTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCLowerPriceTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCUpperPriceTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/TimeTolerance[@type='days']/@limit) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCLowerTimeToleranceInDays</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/TimeTolerance[@type='days']/@limit)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/TimeTolerance[@type='days']/@limit) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">OCUpperTimeToleranceInDays</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/TimeTolerance[@type='days']/@limit)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/ASNInstruction/@value) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">ASNValue</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/ASNInstruction/@value)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/ASNInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">ASNLowerQtyTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/ASNInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/ASNInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">ASNUpperQtyTolerancePercent</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/ASNInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/InvoiceInstruction/@value) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">INVValue</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/InvoiceInstruction/@value)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/InvoiceInstruction/@verificationType) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">INVVerification</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/InvoiceInstruction/@verificationType)"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="normalize-space($keys/SESInstruction/@value) != ''">
      <xsl:element name="pidx:SpecialInstructions">
        <xsl:attribute name="instructionIndicator">Other</xsl:attribute>
        <xsl:attribute name="definitionOfOther">SESValue</xsl:attribute>
        <xsl:value-of select="normalize-space($keys/SESInstruction/@value)"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
