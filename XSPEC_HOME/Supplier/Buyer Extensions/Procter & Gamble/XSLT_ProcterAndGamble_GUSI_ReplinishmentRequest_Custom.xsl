<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:plan="urn:ean.ucc:plan:2">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>
   <xsl:template match="//sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier">
      <sh:InstanceIdentifier>100002</sh:InstanceIdentifier>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/plan:replenishmentRequest/buyer/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space((//Combined/source/cXML/Message/ProductActivityMessage/ProductActivityDetails/Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier)[1]) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space((//Combined/source/cXML/Message/ProductActivityMessage/ProductActivityDetails/Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier)[1])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/entityIdentification/uniqueCreatorIdentification">
      <xsl:element name="uniqueCreatorIdentification">
         <xsl:value-of select="//ProductActivityMessage/ProductActivityHeader/@messageID"/>
      </xsl:element>
   </xsl:template>
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
