<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <!--  CI-2260   please keep indent = yes; FG can't consume single line messages-->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
    <xsl:param name="anReceiverID"/>
    <xsl:include href="../../../common/FORMAT_cXML_0000_FieldGlass_0000.xsl"/>
<!--    <xsl:include href="FORMAT_cXML_0000_FieldGlass_0000.xsl"/>-->
    <xsl:template match="Combined">
        <!--Prepare the CrossRef path-->
        <List>
            <xsl:call-template name="FGHeader"/>
            <SOW>
                <xsl:call-template name="FGSOW">
                    <xsl:with-param name="p_header_path"
                        select="Payload/cXML/Request/OrderRequest/OrderRequestHeader"/>
                    <xsl:with-param name="p_item_path"
                        select="Payload/cXML/Request/OrderRequest/ItemOut"/>
                    <xsl:with-param name="p_from_identity"
                        select="Payload/cXML/Header/From/Credential[translate(@domain, 'NETWORKID', 'networkid') = 'networkid'][1]/Identity"/>
<!--                    * CI-1802 { Inclusion to pass accounting info                 -->
                    <xsl:with-param name="p_acc_info" select="AccountInfo"/>
<!--                    * }CI-1802                      -->
                </xsl:call-template>
            </SOW>
        </List>
    </xsl:template>
</xsl:stylesheet>
