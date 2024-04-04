<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:deliver="urn:ean.ucc:deliver:2">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/entityIdentification/uniqueCreatorIdentification">
      <xsl:element name="uniqueCreatorIdentification">
         <xsl:value-of select="//cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptID"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID']) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID'])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/entityIdentification/uniqueCreatorIdentification">
      <xsl:element name="uniqueCreatorIdentification">
         <xsl:value-of select="'ReceivingAdvice'"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID']) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID'])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandHeader/entityIdentification/uniqueCreatorIdentification">
      <xsl:element name="uniqueCreatorIdentification">
         <xsl:value-of select="'ReceivingAdvice'"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandHeader/entityIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID']) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID'])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/deliver:receivingAdvice/receivingAdviceIdentification/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID']) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID'])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/deliver:receivingAdvice/receivingAdviceItemContainmentLineItem/purchaseOrder/documentLineReference/documentReference/contentOwner/additionalPartyIdentification/additionalPartyIdentificationValue">
      <xsl:choose>
         <xsl:when test="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID']) != ''">
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="normalize-space(//Combined/source/cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[@name = 'shipToID'])"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="additionalPartyIdentificationValue">
               <xsl:value-of select="."/>
            </xsl:element>
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