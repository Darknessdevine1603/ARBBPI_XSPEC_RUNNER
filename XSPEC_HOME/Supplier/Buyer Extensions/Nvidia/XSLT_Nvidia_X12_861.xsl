<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  --> 
   <xsl:template match="ReceiptRequest/ReceiptOrder/ReceiptItem/ReceiptItemReference">      
         <xsl:choose>
            <xsl:when test="exists(ShipNoticeIDInfo)">
               <ReceiptItemReference>
               <xsl:copy-of select="@*"/>
               <xsl:copy-of select="ItemID"/>
               <xsl:copy-of select="Description"/>
               <xsl:copy-of select="ManufacturerPartID"/>
               <xsl:copy-of select="ManufacturerName"/>
               <ShipNoticeReference>
                  <xsl:attribute name="shipNoticeID">                     
                        <xsl:value-of select="ShipNoticeIDInfo/@shipNoticeID"/>
                  </xsl:attribute>
                  <DocumentReference>
                     <xsl:attribute name="payloadID"></xsl:attribute>
                  </DocumentReference>
               </ShipNoticeReference>
               <xsl:copy-of select="ShipNoticeLineItemReference"/>
               <xsl:copy-of select="ReferenceDocumentInfo"/>                  
               </ReceiptItemReference>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="."/>
            </xsl:otherwise>
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
