<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:deliver="urn:ean.ucc:deliver:2">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="anAlternativeReceiver"/>
   <xsl:template match="//source"/>
   <xsl:template match="//sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender">
      <xsl:element name="sh:Sender">
         <xsl:copy-of select="child::*"/>
         <xsl:element name="sh:ContactInformation">
            <xsl:element name="sh:ContactTypeIdentifier">
               <xsl:text>Buyer</xsl:text>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver">
      <xsl:element name="sh:Receiver">
         <xsl:copy-of select="child::*"/>
         <xsl:element name="sh:ContactInformation">
            <xsl:element name="sh:ContactTypeIdentifier">
               <xsl:text>Seller</xsl:text>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="$anAlternativeReceiver != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="$anAlternativeReceiver"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="$anAlternativeReceiver != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="$anAlternativeReceiver"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandHeader/entityIdentification/uniqueCreatorIdentification">
      <xsl:choose>
         <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityHeader/@messageID) != ''">
            <xsl:element name="uniqueCreatorIdentification">
               <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityHeader/@messageID)"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandHeader/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="$anAlternativeReceiver != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="$anAlternativeReceiver"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/deliver:consumptionReport/consumptionReportIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="$anAlternativeReceiver != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="$anAlternativeReceiver"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/deliver:consumptionReport/buyer/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="/Combined/source/cXML/Message/ProductActivityMessage/ProductActivityDetails/Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="(/Combined/source/cXML/Message/ProductActivityMessage/ProductActivityDetails/Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier)[1]"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
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
