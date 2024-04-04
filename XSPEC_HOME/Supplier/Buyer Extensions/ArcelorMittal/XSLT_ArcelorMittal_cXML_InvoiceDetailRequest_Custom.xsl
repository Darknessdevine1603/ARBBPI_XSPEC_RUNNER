<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->


   <!--BY and IV translate to Buyer, check the sequence of occurence before making update-->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact/@role[. = 'buyer']">
      <xsl:choose>
         <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) = 0 and  //G_SG2/S_NAD[D_3035 = 'BY']/preceding::G_SG2/S_NAD[D_3035 = 'IV']">
            <xsl:attribute name="role">billTo</xsl:attribute>
         </xsl:when>
         <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) = 0 and  //G_SG2/S_NAD[D_3035 = 'IV']/preceding::G_SG2/S_NAD[D_3035 = 'BY']">
            <xsl:attribute name="role">soldTo</xsl:attribute>
         </xsl:when>
         <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) = 1 and //G_SG2/S_NAD[D_3035 = 'BY']/preceding::G_SG2/S_NAD[D_3035 = 'IV']">
            <xsl:attribute name="role">soldTo</xsl:attribute>
         </xsl:when>
         <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) = 1 and //G_SG2/S_NAD[D_3035 = 'IV']/preceding::G_SG2/S_NAD[D_3035 = 'BY']">
            <xsl:attribute name="role">billTo</xsl:attribute>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) =0 and count(../following::Contact/@role[. = 'buyer']) =0 and //G_SG2/S_NAD/D_3035 = 'IV'">
                  <xsl:attribute name="role">billTo</xsl:attribute>
               </xsl:when>
               <xsl:when test="count(../preceding::Contact/@role[. = 'buyer']) =0 and count(../following::Contact/@role[. = 'buyer']) =0 and //G_SG2/S_NAD/D_3035 = 'BY'">
                  <xsl:attribute name="role">soldTo</xsl:attribute>
               </xsl:when>              
               <xsl:otherwise>
                  <xsl:copy-of select="."/>
               </xsl:otherwise>
            </xsl:choose>
            
         </xsl:otherwise>
         
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact/@role[. = 'supplierAccount']">
      <xsl:attribute name="role">from</xsl:attribute>
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
