<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.api.org/pidXML/v1.0" version="1.0" exclude-result-prefixes="pidx">
   
   <!-- Use this template to format dates into valid xCBL formats.  Expects Input dates in yyyy-mm-dd format -->
   <!-- Converts Ariba Date into xCBL date.  Ariba date comes in following format:
            2011-03-11T12:54:29-08:00
            xCBL can't have the "-" separators for the yyyy-mm-dd

			2014-08-13 : Add receiptNo extrinsic on Invoice Item detail
			2015-08-20 : Default Invoice line item number reference to Invoice line item when non PO reference
			2015-09-08 : Add condition of Spend_limit before creating requiresServiceEntry attribute and blanket item
        -->
   
   <xsl:template name="formatDate">
      <xsl:param name="input"/>
      <xsl:variable name="formattedDate">
         
         <xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2),'T',substring($input,9,2),':',substring($input,11,2),':',substring($input,13,2),'-0:00')"/>
         
      </xsl:variable>
      <xsl:value-of select="$formattedDate"/>
   </xsl:template>
   
   <xsl:template name="formatMoney">
      <xsl:param name="value"/>
      <xsl:param name="currency"/>
      <Money>
         <xsl:choose>
            <xsl:when test="$currency">
               <xsl:attribute name="currency">
                  <xsl:value-of select="$currency"/>
               </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="currency"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="$value and $value!=''">
               <xsl:value-of select="format-number($value,'#0.00##')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>0.00</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </Money>
   </xsl:template>
   
</xsl:stylesheet>
