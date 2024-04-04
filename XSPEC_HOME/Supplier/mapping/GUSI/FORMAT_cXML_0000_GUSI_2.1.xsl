<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:plan="urn:ean.ucc:plan:2"
                exclude-result-prefixes="#all" version="2.0">
	<!-- Functions -->

	<xsl:template name="createGUSIHeader">
		<xsl:param name="version"/>
		<xsl:param name="hdrversion"/>
		<xsl:param name="type"/>
		<xsl:param name="time"/>

		<sh:StandardBusinessDocumentHeader>
			<sh:HeaderVersion>
				<xsl:choose>
					<xsl:when test="$hdrversion!=''">
						<xsl:value-of select="$hdrversion"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>1.0</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</sh:HeaderVersion>
			<sh:Sender>
				<sh:Identifier>
					<xsl:attribute name="Authority">
						<xsl:text>EAN.UCC</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$anAlternativeSender"/>
				</sh:Identifier>
			</sh:Sender>
			<sh:Receiver>
				<sh:Identifier>
					<xsl:attribute name="Authority">
						<xsl:text>EAN.UCC</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$anAlternativeReceiver"/>
				</sh:Identifier>
			</sh:Receiver>
			<sh:DocumentIdentification>
				<sh:Standard>EAN.UCC</sh:Standard>
				<sh:TypeVersion>
					<xsl:value-of select="$version"/>
				</sh:TypeVersion>
				<sh:InstanceIdentifier>
					<xsl:value-of select="$anCorrelationID"/>
				</sh:InstanceIdentifier>
				<sh:Type>
					<xsl:value-of select="$type"/>
				</sh:Type>
				<sh:MultipleType>false</sh:MultipleType>
				<sh:CreationDateAndTime>
					<xsl:value-of select="$time"/>
				</sh:CreationDateAndTime>
			</sh:DocumentIdentification>
		</sh:StandardBusinessDocumentHeader>
	</xsl:template>

	<xsl:template name="createContentOwner">
		<xsl:param name="gln"/>
		<xsl:param name="additionalPartyIdentificationValue"/>
		<xsl:param name="additionalPartyIdentificationType"/>

		<gln>
			<xsl:choose>
				<xsl:when test="$gln!=''">
					<xsl:value-of select="$gln"/>
				</xsl:when>
				<xsl:otherwise>0000000000000</xsl:otherwise>
			</xsl:choose>
		</gln>
		<xsl:choose>
			<xsl:when test="$additionalPartyIdentificationValue!=''">
				<additionalPartyIdentification>
					<additionalPartyIdentificationValue>
						<xsl:value-of select="$additionalPartyIdentificationValue"/>
					</additionalPartyIdentificationValue>
					<additionalPartyIdentificationType>
						<xsl:choose>
							<xsl:when test="$additionalPartyIdentificationType!=''">
								<xsl:value-of select="$additionalPartyIdentificationType"/>
							</xsl:when>
							<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
						</xsl:choose>
					</additionalPartyIdentificationType>
				</additionalPartyIdentification>
			</xsl:when>
			<xsl:when test="$anAlternativeSender!=''">
				<additionalPartyIdentification>
					<additionalPartyIdentificationValue>
						<xsl:value-of select="normalize-space($anAlternativeSender)"/>
					</additionalPartyIdentificationValue>
					<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
				</additionalPartyIdentification>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="cxmlDate"/>
		<xsl:if test="$cxmlDate">
			<xsl:variable name="date">
				<xsl:choose>
					<xsl:when test="contains($cxmlDate,'T')">
						<xsl:value-of select="substring-before($cxmlDate,'T')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($cxmlDate,1,10)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="tempTime">
				<xsl:value-of select="substring-after($cxmlDate,'T')"/>
			</xsl:variable>
			<xsl:variable name="time">
				<xsl:if test="$tempTime!=''">
					<xsl:choose>
						<xsl:when test="contains($tempTime,'-')">
							<xsl:value-of select="substring-before($tempTime,'-')"/>
						</xsl:when>
						<xsl:when test="contains($tempTime,'+')">
							<xsl:value-of select="substring-before($tempTime,'+')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($cxmlDate,'T')">
					<xsl:value-of select="concat($date,'T',$time)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$date"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
