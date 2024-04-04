<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
  <xsl:template name="convertToAribaDate">
    <xsl:param name="Date"/>
    <xsl:param name="Time"/>
    <xsl:param name="TimeCode"/>
    <xsl:variable name="timeZone">
      <xsl:choose>
        <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
          <xsl:value-of
            select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
          />
        </xsl:when>
        <xsl:otherwise>+00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="temDate">
      <xsl:value-of
        select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
      />
    </xsl:variable>
    <xsl:variable name="tempTime">
      <xsl:choose>
        <xsl:when test="$Time != '' and string-length($Time) = 6">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
          />
        </xsl:when>
        <xsl:when test="$Time != '' and string-length($Time) = 4">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
        </xsl:when>
        <xsl:otherwise>T12:00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
  </xsl:template>
  <xsl:template name="createcXMLHeader">
    <xsl:element name="Header">
      <xsl:element name="From">
        <xsl:element name="Credential">
          <xsl:attribute name="domain">NetworkID</xsl:attribute>
          <xsl:element name="Identity">
            <xsl:value-of select="$anSupplierANID"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="To">
        <xsl:element name="Credential">
          <xsl:attribute name="domain">NetworkID</xsl:attribute>
          <xsl:element name="Identity">
            <xsl:value-of select="$anBuyerANID"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Sender">
        <xsl:element name="Credential">
          <xsl:attribute name="domain">NetworkID</xsl:attribute>
          <xsl:element name="Identity">
            <xsl:value-of select="$anProviderANID"/>
          </xsl:element>
          <xsl:element name="SharedSecret">
            <xsl:value-of select="$anSharedSecrete"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="UserAgent">
          <xsl:value-of select="'Ariba Supplier'"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- CG: IG-16765 1500 Extrinsics -->
  <xsl:template name="getLookupValues">
    <xsl:param name="cXMLDocType"/>
    <xsl:variable name="buyerSpecificT" select="/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUPTABLE_ALL.xml"/>
    <xsl:variable name="allBuyersT" select="/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUPTABLE_ALL.xml"/>
    <!--xsl:variable name="buyerSpecificT" select="concat('pd', '_', $anSupplierANID, '_LOOKUPTABLE_', $anBuyerANID, '.xml')"/>
    <xsl:variable name="allBuyersT" select="concat('pd', '_', $anSupplierANID, '_LOOKUPTABLE_ALL.xml')"/-->
    <xsl:variable name="lookupFileT">
      <xsl:choose>
        <xsl:when test="doc-available($buyerSpecificT)">
          <xsl:value-of select="$buyerSpecificT"/>
        </xsl:when>
        <xsl:when test="doc-available($allBuyersT)">
          <xsl:value-of select="$allBuyersT"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'NotAvailable'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <MappingLookup>
      <xsl:choose>
        <xsl:when test="$lookupFileT!='NotAvailable'">
          <xsl:variable name="lookupTable" select="document($lookupFileT)"/>
          <EnableStandardExtrinsics>
            <xsl:value-of select="$lookupTable/LOOKUPTABLE/Parameter[Name='EnableStandardExtrinsics' and DocumentType = $cXMLDocType][1]/ListOfItems/Item[Name = 'ASC-X12']/Value"/>
          </EnableStandardExtrinsics>
        </xsl:when>
      </xsl:choose>
    </MappingLookup>
  </xsl:template>
  
</xsl:stylesheet>
