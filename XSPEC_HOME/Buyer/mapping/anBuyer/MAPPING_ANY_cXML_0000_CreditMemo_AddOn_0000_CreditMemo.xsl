<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
  exclude-result-prefixes="#all" version="2.0"> 
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <xsl:param name="anReceiverID"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anSourceDocumentType"/>
  <xsl:param name="anPayloadID"/>
<!--  <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
      <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
  <xsl:variable name="v_empty"/>
  <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
  <xsl:variable name="v_sysid">
    <xsl:call-template name="MultiErpSysIdIN">
      <xsl:with-param name="p_ansysid"
        select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
    </xsl:call-template>
  </xsl:variable>
  <!--Prepare the CrossRef path-->
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
      <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
      <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
    </xsl:call-template>
  </xsl:variable>
  <!--Get the IsLogicalSystemEnabled details-->
  <xsl:variable name="v_LsEnabled">
    <!--Call Template for IsLogicalSystemEnabled-->
    <xsl:call-template name="LogicalSystemEnabled">
      <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>  
  <xsl:variable name="v_defaultLang">
    <xsl:call-template name="FillDefaultLang">
      <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <!--Get the Language code-->
  <xsl:variable name="v_lang">
    <xsl:choose>
      <xsl:when
        test="Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/@xml:lang != ''">
        <xsl:value-of
          select="Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/@xml:lang"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$v_defaultLang"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="Combined">
    <n0:CreditMemoMsg>
      <MessageHeader>
        <xsl:choose>
          <xsl:when test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID">
            <ID>
              <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID"/>
            </ID>
          </xsl:when>
          <xsl:otherwise>
            <ID>
              <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>
            </ID>
          </xsl:otherwise>
        </xsl:choose>
        <AribaNetworkPayloadID>
          <xsl:value-of select="Payload/cXML/@payloadID"/>
        </AribaNetworkPayloadID>
        <AribaNetworkID>
          <xsl:value-of select="$anReceiverID"/>
        </AribaNetworkID>        
        <CreationDateTime>
          <xsl:value-of select="(current-dateTime())"/>
        </CreationDateTime>
        <RecipientParty>
          <InternalID>           
            <xsl:choose>
              <xsl:when test="$v_LsEnabled!= ''">   
                <xsl:attribute name="schemeID">
                  <xsl:value-of select="'LS'"/>
                </xsl:attribute>                
                <xsl:value-of select="$v_sysid"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="schemeID">
                  <xsl:value-of select="'LI'"/>
                </xsl:attribute>                 
                <xsl:value-of
                  select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                />                
              </xsl:otherwise>
            </xsl:choose>
          </InternalID>
        </RecipientParty>
      </MessageHeader>
      <Item>
        <xsl:for-each select="Payload/cXML/Request/InvoiceDetailRequest">
          <VendorID>
            <xsl:value-of select="../../Header/From/Credential[@domain = 'VendorID']/Identity"/>
          </VendorID>
          <ERPInvoiceNo>
            <xsl:value-of
              select="InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID"
            />
          </ERPInvoiceNo>
          <ERPInvoiceDate>
            <xsl:value-of
              select="substring(InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceDate, 1, 10)"
            />
          </ERPInvoiceDate>
          <ASNInvoiceNo>
            <xsl:choose>
              <xsl:when test="InvoiceDetailRequestHeader/Extrinsic[@name = 'invoiceSourceDocument'] = 'NoOrderInformation' 
                or InvoiceDetailRequestHeader/Extrinsic[@name = 'invoiceSourceDocument'] = 'ExternalPurchaseOrder'">                    
                    <xsl:value-of select="substring(InvoiceDetailRequestHeader/@invoiceID, 1, string-length(InvoiceDetailRequestHeader/@invoiceID) - 2 )"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="InvoiceDetailRequestHeader/@invoiceID"/> 
              </xsl:otherwise>
            </xsl:choose>
          </ASNInvoiceNo>
          <LogicalSystem>
            <xsl:value-of
              select="InvoiceDetailRequestHeader/@invoiceOrigin"/>
          </LogicalSystem>
          <DocumentDate>
            <xsl:value-of
              select="substring(InvoiceDetailRequestHeader/@invoiceDate, 1, 10)"
            />
          </DocumentDate>
          <DocumentTime>
            <xsl:value-of
              select="substring(InvoiceDetailRequestHeader/@invoiceDate, 12, 8)"
            />
          </DocumentTime>
          <DocumentStatus>
            <xsl:value-of
              select="InvoiceDetailRequestHeader/@operation"/>
          </DocumentStatus>
          <FIInvoice>
            <xsl:if test="InvoiceDetailRequestHeader/Extrinsic[@name = 'invoiceSourceDocument'] = 'NoOrderInformation' 
              or InvoiceDetailRequestHeader/Extrinsic[@name = 'invoiceSourceDocument'] = 'ExternalPurchaseOrder'">
              <xsl:value-of select="'true'"/>
            </xsl:if>                     
          </FIInvoice>
              <CompanyCode>
                <xsl:value-of select="InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo']/@addressID"/>
              </CompanyCode>
          <xsl:if test="string-length(InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo']/Name) > 0">              
                <CompanyName>
                  <xsl:value-of select="InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo']/Name"/> 
                </CompanyName>
              </xsl:if>
            <RemitToPartner>
              <xsl:if test="string-length(InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'remitTo']/@addressID) > 0">               
                <InternalID>
                  <xsl:value-of select="InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'remitTo']/@addressID"/>
                </InternalID>
              </xsl:if>
              <xsl:if test="string-length(InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'remitTo']/Name) > 0">
                <OrganisationFormattedName>
                  <xsl:value-of select="InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'remitTo']/Name"/>
                </OrganisationFormattedName>              
            </xsl:if>
            </RemitToPartner>
          <AribaComment>
            <!--Call Template to fill Comments-->
            <xsl:call-template name="CommentsFillProxyIn">
              <xsl:with-param name="p_comments"
                select="InvoiceDetailRequestHeader/Comments"/>
              <xsl:with-param name="p_lang" select="$v_lang"/>
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
          </AribaComment>
        </xsl:for-each>
        <xsl:call-template name="AttachWithPayload"/> 
      </Item>
    </n0:CreditMemoMsg>
  </xsl:template>
  
  <xsl:template name="AttachWithPayload">
    <xsl:variable name="eachAtt" select="AttachmentList/Attachment"/>
    <xsl:variable name="operation" select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@operation"/>
    <xsl:if test="$eachAtt|$operation!='delete'">
      <Attachment>
        <xsl:for-each select="AttachmentList/Attachment">
          <xsl:variable name="count" select="position()"/>
          <Item>
            <FileName>
              <xsl:value-of select="$eachAtt[$count]/AttachmentName"/>
            </FileName>
            <ContentType>
              <xsl:value-of select="$eachAtt[$count]/AttachmentType"/>
            </ContentType>
            <ContentId>
              <xsl:value-of select="$eachAtt[$count]/AttachmentID"/>
            </ContentId>
            <Content>
              <xsl:value-of select="$eachAtt[$count]/AttachmentContent"/>
            </Content>
          </Item>
        </xsl:for-each>
        <Item>
          <FileName>
            <xsl:value-of select="'Payload.xml'"/>
          </FileName>
          <ContentType>
            <xsl:value-of select="'xml'"/>
          </ContentType>
          <ContentId>
            <xsl:value-of select="'PAYLOAD'"/>
          </ContentId>
          <xsl:variable name="cXMLSerialized">
            <xsl:apply-templates select="Payload/cXML" mode="escape"/>  
          </xsl:variable>
          <Content>
            <xsl:value-of select="$cXMLSerialized"/>  
          </Content>
        </Item>
      </Attachment>
    </xsl:if>  
  </xsl:template>
  
  <xsl:template match="*" mode="escape">
    <!-- Begin opening tag -->
    
      <xsl:value-of select="'&lt;'"/>
    
    <xsl:value-of select="name()"/>
    <!-- Attributes -->
    <xsl:for-each select="@*">
      
        <xsl:value-of select="' '"/>
      
      <xsl:value-of select="name()"/>
      
        <xsl:value-of select="'=&quot;'"/>
      
      <xsl:call-template name="escape-xml">
        <xsl:with-param name="text" select="."/>
      </xsl:call-template>
     
        <xsl:value-of select="'&quot;'"/>
      
    </xsl:for-each>
    <!-- End opening tag -->
    
      <xsl:value-of select="'&gt;'"/>
    
    <!-- Content (child elements, text nodes, and PIs) -->
    <xsl:apply-templates select="node()" mode="escape"/>
    <!-- Closing tag -->
    
      <xsl:value-of select="'&lt;/'"/>
    
    <xsl:value-of select="name()"/>
    
      <xsl:value-of select="'&gt;'"/>
  </xsl:template>
  <xsl:template match="text()" mode="escape">
    <xsl:call-template name="escape-xml">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="escape">
    
      <xsl:value-of select="'&lt;?'"/>
    
    <xsl:value-of select="name()"/>
    
      <xsl:value-of select="' '"/>
    
    <xsl:call-template name="escape-xml">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
    
      <xsl:value-of select="'?&gt;'"/>
    
  </xsl:template>
  <xsl:template name="escape-xml">
    <xsl:param name="text"/>
    <xsl:if test="$text != ''">
      <xsl:variable name="head" select="substring($text, 1, 1)"/>
      <xsl:variable name="tail" select="substring($text, 2)"/>
      <xsl:choose>
        <xsl:when test="$head = '&amp;'">
          <xsl:value-of select="'&amp;amp;'"/>
        </xsl:when>
        <xsl:when test="$head = '&lt;'">
          <xsl:value-of select="'&amp;lt;'"/>
        </xsl:when>
        <xsl:when test="$head = '&gt;'">
          <xsl:value-of select="'&amp;gt;'"/>
        </xsl:when>
        <xsl:when test="$head = '&quot;'">
          <xsl:value-of select="'&amp;quot;'"/>
        </xsl:when>
        <xsl:when test="$head = &quot;'&quot;">
          <xsl:value-of select="'&amp;apos;'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$head"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="escape-xml">
        <xsl:with-param name="text" select="$tail"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
