<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:hci="http://sap.com/it/"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="exchange"/>
    <xsl:template match="n0:RequestForQuotationS4Request">
        <n0:RequestForQuotationS4Request>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="MessageHeader/ID"/>
                </ID>
                <UUID>
                    <xsl:value-of select="MessageHeader/UUID"/>
                </UUID>
                <ReferenceID>
                    <xsl:value-of select="MessageHeader/ReferenceID"/>
                </ReferenceID>
                <ReferenceUUID>
                    <xsl:value-of select="MessageHeader/ReferenceUUID"/>
                </ReferenceUUID>
                <CreationDateTime>
                    <xsl:value-of select="MessageHeader/CreationDateTime"/>
                </CreationDateTime>
                <TestDataIndicator>
                    <xsl:value-of select="MessageHeader/TestDataIndicator"/>
                </TestDataIndicator>
                <ReconciliationIndicator>
                    <xsl:value-of select="MessageHeader/ReconciliationIndicator"/>
                </ReconciliationIndicator>
                <SenderBusinessSystemID>
                    <xsl:value-of select="MessageHeader/SenderBusinessSystemID"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="MessageHeader/RecipientBusinessSystemID"/>
                </RecipientBusinessSystemID>
                <!--                Adding Action Code for Cancellation use case for 4BL and 4QN - IG-32617 CI-2218 -->
                <ActionCode>
                    <xsl:value-of select="RequestForQuotation/ActionCode"/>
                </ActionCode>
            </MessageHeader>
            <RequestForQuotation>
                <RequestForQuotationID>
                    <xsl:value-of select="RequestForQuotation/RequestForQuotationID"/>
                </RequestForQuotationID>
                <RequestForQuotationName>
                    <xsl:value-of select="RequestForQuotation/RequestForQuotationName"/>
                </RequestForQuotationName>
                <RFQDocumentType>
                    <xsl:value-of select="RequestForQuotation/RFQDocumentType"/>
                </RFQDocumentType>
                <RFQCategory>
                    <xsl:value-of select="RequestForQuotation/RFQCategory"/>
                </RFQCategory>
                <Language>
                    <xsl:value-of select="RequestForQuotation/Language"/>
                </Language>
                <CreationDate>
                    <xsl:value-of select="RequestForQuotation/CreationDate"/>
                </CreationDate>
                <RFQPublishingDate>
                    <xsl:value-of select="RequestForQuotation/RFQPublishingDate"/>
                </RFQPublishingDate>
                <QuotationLatestSubmissionDate>
                    <xsl:value-of select="RequestForQuotation/QuotationLatestSubmissionDate"/>
                </QuotationLatestSubmissionDate>
                <BindingPeriodEndDate>
                    <xsl:value-of select="RequestForQuotation/BindingPeriodEndDate"/>
                </BindingPeriodEndDate>
                <LatestRegistrationDate>
                    <xsl:value-of select="RequestForQuotation/LatestRegistrationDate"/>
                </LatestRegistrationDate>
                <DocumentCurrency>
                    <xsl:value-of select="RequestForQuotation/DocumentCurrency"/>
                </DocumentCurrency>
                <CompanyCode>
                    <xsl:value-of select="RequestForQuotation/CompanyCode"/>
                </CompanyCode>
                <PurchasingOrganization>
                    <xsl:value-of select="RequestForQuotation/PurchasingOrganization"/>
                </PurchasingOrganization>
                <PurchasingGroup>
                    <xsl:value-of select="RequestForQuotation/PurchasingGroup"/>
                </PurchasingGroup>
                    <HeaderIncoterms>
                        <IncotermsClassification>
                            <xsl:value-of
                                select="RequestForQuotation/HeaderIncoterms/IncotermsClassification"
                            />
                        </IncotermsClassification>
                        <IncotermsVersion>
                            <xsl:value-of
                                select="RequestForQuotation/HeaderIncoterms/IncotermsVersion"/>
                        </IncotermsVersion>
                        <IncotermsLocation1>
                            <xsl:value-of
                                select="RequestForQuotation/HeaderIncoterms/IncotermsLocation1"/>
                        </IncotermsLocation1>
                        <IncotermsLocation2>
                            <xsl:value-of
                                select="RequestForQuotation/HeaderIncoterms/IncotermsLocation2"/>
                        </IncotermsLocation2>
                    </HeaderIncoterms>
                <FollowOnDocumentType>
                    <xsl:value-of select="RequestForQuotation/FollowOnDocumentType"/>
                </FollowOnDocumentType>
                <FollowOnDocumentCategory>
                    <xsl:value-of select="RequestForQuotation/FollowOnDocumentCategory"/>
                </FollowOnDocumentCategory>
                <xsl:for-each select="RequestForQuotation/RFQBidder">
                    <RFQBidder>
                        <Supplier>
                            <xsl:value-of select="Supplier"/>
                        </Supplier>
                    </RFQBidder>
                </xsl:for-each>
                <SupplierSelectorMatchingType>
                    <xsl:value-of select="RequestForQuotation/SupplierSelectorMatchingType"/>
                </SupplierSelectorMatchingType>
                <EmployeeResponsible>
                    <Employee>
                        <xsl:value-of select="RequestForQuotation/EmployeeResponsible/Employee"/>
                    </Employee>
                    <Address>
                        <FormOfAddress>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/FormOfAddress"
                            />
                        </FormOfAddress>
                        <FormOfAddressName>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/FormOfAddressName"
                            />
                        </FormOfAddressName>
                        <FullName>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/FullName"/>
                        </FullName>
                        <StreetName>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/StreetName"
                            />
                        </StreetName>
                        <HouseNumber>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/HouseNumber"
                            />
                        </HouseNumber>
                        <PostalCode>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/PostalCode"
                            />
                        </PostalCode>
                        <CityName>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/CityName"/>
                        </CityName>
                        <Country>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/Country"/>
                        </Country>
                        <Region>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/Region"/>
                        </Region>
                        <District>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/District"/>
                        </District>
                        <County>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/County"/>
                        </County>
                        <Building>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/Building"/>
                        </Building>
                        <Floor>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/Floor"/>
                        </Floor>
                        <RoomNumber>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/RoomNumber"
                            />
                        </RoomNumber>
                        <FormattedPhoneNumber>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/FormattedPhoneNumber"
                            />
                        </FormattedPhoneNumber>
                        <PhoneNumber>
                            <AreaID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/AreaID"
                                />
                            </AreaID>
                            <SubscriberID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/SubscriberID"
                                />
                            </SubscriberID>
                            <ExtensionID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/ExtensionID"
                                />
                            </ExtensionID>
                            <CountryCode>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryCode"
                                />
                            </CountryCode>
                            <CountryDiallingCode>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryDiallingCode"
                                />
                            </CountryDiallingCode>
                            <CountryName>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of
                                        select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryName/@languageCode"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryName"
                                />
                            </CountryName>
                        </PhoneNumber>
                        <FormattedFaxNumber>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/FormattedFaxNumber"
                            />
                        </FormattedFaxNumber>
                        <FaxNumber>
                            <AreaID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/AreaID"
                                />
                            </AreaID>
                            <SubscriberID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/SubscriberID"
                                />
                            </SubscriberID>
                            <ExtensionID>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/ExtensionID"
                                />
                            </ExtensionID>
                            <CountryCode>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryCode"
                                />
                            </CountryCode>
                            <CountryDiallingCode>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryDiallingCode"
                                />
                            </CountryDiallingCode>
                            <CountryName>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of
                                        select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryName/@languageCode"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="RequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryName"
                                />
                            </CountryName>
                        </FaxNumber>
                        <EmailAddress>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/EmailAddress"
                            />
                        </EmailAddress>
                        <CorrespondenceLanguage>
                            <xsl:value-of
                                select="RequestForQuotation/EmployeeResponsible/Address/CorrespondenceLanguage"
                            />
                        </CorrespondenceLanguage>
                    </Address>
                </EmployeeResponsible>
                <xsl:for-each select="RequestForQuotation/TextCollection">
                    <TextCollection>
                        <ContentText>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="ContentText/@languageCode"/>
                            </xsl:attribute>
                            <xsl:value-of select="ContentText"/>
                        </ContentText>
                        <TypeCode>
                            <xsl:value-of select="TypeCode"/>
                        </TypeCode>
                        <MimeType>
                            <xsl:value-of select="MimeType"/>
                        </MimeType>
                    </TextCollection>
                </xsl:for-each>
                <!--                    Attachments for 4BL-->
                <xsl:if test="exists(RequestForQuotation/Attachment)">
                    <xsl:for-each select="RequestForQuotation/Attachment">
                        <Attachment>
                            <xsl:attribute name="FileName">
                                <xsl:value-of select="@FileName"/>
                            </xsl:attribute>
                            <xsl:attribute name="FileSize">
                                <xsl:value-of select="@FileSize"/>
                            </xsl:attribute>
                            <xsl:attribute name="MimeType">
                                <xsl:value-of select="@MimeType"/>
                            </xsl:attribute>
                            <xop:Include>
                                <xsl:value-of select="namespace-uri(xop)"/>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href"
                                    />
                                </xsl:attribute>
                            </xop:Include>
                        </Attachment>
                    </xsl:for-each>
                </xsl:if>
                <xsl:variable name="ancXMLAttachmentsHeader">
                    <xsl:for-each select="RequestForQuotation/Attachment">
                        <xsl:value-of
                            select="concat(string-join((*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href, @FileName, @MimeType), ';'), '#')"
                        />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="RequestForQuotation/RequestForQuotationItem">
                    <RequestForQuotationItem>
                        <RequestForQuotationItemID>
                            <xsl:value-of select="RequestForQuotationItemID"/>
                        </RequestForQuotationItemID>
                        <PurchasingDocumentItemText>
                            <xsl:value-of select="PurchasingDocumentItemText"/>
                        </PurchasingDocumentItemText>
                        <Plant>
                            <xsl:value-of select="Plant"/>
                        </Plant>
                        <Material>
                            <xsl:value-of select="Material"/>
                        </Material>
                        <xsl:for-each select="MaterialDescription">
                            <MaterialDescription>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="@languageCode"/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </MaterialDescription>
                        </xsl:for-each>
                        <MaterialGroup>
                            <xsl:value-of select="MaterialGroup"/>
                        </MaterialGroup>
                        <xsl:for-each select="MaterialGroupDescription">
                            <MaterialGroupDescription>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="@languageCode"/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </MaterialGroupDescription>
                        </xsl:for-each>
                        <RequestedQuantity>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of select="RequestedQuantity/@unitCode"/>
                            </xsl:attribute>
                            <xsl:value-of select="RequestedQuantity"/>
                        </RequestedQuantity>
                        <DeliveryDate>
                            <xsl:value-of select="DeliveryDate"/>
                        </DeliveryDate>
                        <StartDate>
                            <xsl:value-of select="PerformancePeriodStartDate"/>
                        </StartDate>
                        <EndDate>
                            <xsl:value-of select="PerformancePeriodEndDate"/>
                        </EndDate>
                        <ItemType>
                            <!-- 4BL Item Hierarchies Feature CI-2464 -->
                            <xsl:choose>
                                <xsl:when test="exists(PurchasingIsItemSet) and lower-case(PurchasingIsItemSet) = 'true'">
                                    <xsl:value-of select="'Composite'"/>
                                </xsl:when>
                                <!-- 4BL Item Hierarchies Feature CI-2464 -->
                                <xsl:otherwise>
                                    <xsl:if test="ProductType = '1'">Item</xsl:if>
                                    <xsl:if test="ProductType = '2'">Lean</xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ItemType>
                        <ItemClassification>
                            <xsl:if test="ProductType = '1'">Material</xsl:if>
                            <xsl:if test="ProductType = '2'">Service</xsl:if>
                        </ItemClassification>
                        <!-- 4BL Item Hierarchies Feature CI-2464 -->
                        <xsl:if test="exists(PurchasingParentItem) and number(PurchasingParentItem) > 0">
                            <ParentID>
                                <xsl:value-of select="number(PurchasingParentItem)"/>
                            </ParentID>
                        </xsl:if>
                        <xsl:if test="exists(PurgExternalSortNumber)">
                            <SortOrder>
                                <xsl:value-of select="number(PurgExternalSortNumber)"/>
                            </SortOrder>
                        </xsl:if>    
                        <!-- 4BL Item Hierarchies Feature CI-2464 -->
                        <DeliveryAddress>
                            <FormOfAddress>
                                <xsl:value-of select="DeliveryAddress/FormOfAddress"/>
                            </FormOfAddress>
                            <FormOfAddressName>
                                <xsl:value-of select="DeliveryAddress/FormOfAddressName"/>
                            </FormOfAddressName>
                            <FullName>
                                <xsl:value-of select="DeliveryAddress/FullName"/>
                            </FullName>
                            <StreetName>
                                <xsl:value-of select="DeliveryAddress/StreetName"/>
                            </StreetName>
                            <HouseNumber>
                                <xsl:value-of select="DeliveryAddress/HouseNumber"/>
                            </HouseNumber>
                            <PostalCode>
                                <xsl:value-of select="DeliveryAddress/PostalCode"/>
                            </PostalCode>
                            <CityName>
                                <xsl:value-of select="DeliveryAddress/CityName"/>
                            </CityName>
                            <Country>
                                <xsl:value-of select="DeliveryAddress/Country"/>
                            </Country>
                            <Region>
                                <xsl:value-of select="DeliveryAddress/Region"/>
                            </Region>
                            <District>
                                <xsl:value-of select="DeliveryAddress/District"/>
                            </District>
                            <County>
                                <xsl:value-of select="DeliveryAddress/County"/>
                            </County>
                            <Building>
                                <xsl:value-of select="DeliveryAddress/Building"/>
                            </Building>
                            <Floor>
                                <xsl:value-of select="DeliveryAddress/Floor"/>
                            </Floor>
                            <RoomNumber>
                                <xsl:value-of select="DeliveryAddress/RoomNumber"/>
                            </RoomNumber>
                            <FormattedPhoneNumber>
                                <xsl:value-of select="DeliveryAddress/FormattedPhoneNumber"/>
                            </FormattedPhoneNumber>
                            <PhoneNumber>
                                <AreaID>
                                    <xsl:value-of select="DeliveryAddress/PhoneNumber/AreaID"/>
                                </AreaID>
                                <SubscriberID>
                                    <xsl:value-of select="DeliveryAddress/PhoneNumber/SubscriberID"
                                    />
                                </SubscriberID>
                                <ExtensionID>
                                    <xsl:value-of select="DeliveryAddress/PhoneNumber/ExtensionID"/>
                                </ExtensionID>
                                <CountryCode>
                                    <xsl:value-of select="DeliveryAddress/PhoneNumber/CountryCode"/>
                                </CountryCode>
                                <CountryDiallingCode>
                                    <xsl:value-of
                                        select="DeliveryAddress/PhoneNumber/CountryDiallingCode"/>
                                </CountryDiallingCode>
                                <CountryName>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of
                                            select="DeliveryAddress/PhoneNumber/CountryName/@languageCode"
                                        />
                                    </xsl:attribute>
                                    <xsl:value-of select="DeliveryAddress/PhoneNumber/CountryName"/>
                                </CountryName>
                            </PhoneNumber>
                            <FormattedFaxNumber>
                                <xsl:value-of select="DeliveryAddress/FormattedFaxNumber"/>
                            </FormattedFaxNumber>
                            <FaxNumber>
                                <AreaID/>
                                <SubscriberID>
                                    <xsl:value-of select="DeliveryAddress/FaxNumber/AreaID"/>
                                </SubscriberID>
                                <ExtensionID>
                                    <xsl:value-of select="DeliveryAddress/FaxNumber/ExtensionID"/>
                                </ExtensionID>
                                <CountryCode>
                                    <xsl:value-of select="DeliveryAddress/FaxNumber/CountryCode"/>
                                </CountryCode>
                                <CountryDiallingCode>
                                    <xsl:value-of
                                        select="DeliveryAddress/FaxNumber/CountryDiallingCode"/>
                                </CountryDiallingCode>
                                <CountryName>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of
                                            select="DeliveryAddress/FaxNumber/CountryName/@languageCode"
                                        />
                                    </xsl:attribute>
                                    <xsl:value-of select="DeliveryAddress/FaxNumber/CountryName"/>
                                </CountryName>
                            </FaxNumber>
                            <EmailAddress>
                                <xsl:value-of select="DeliveryAddress/EmailAddress"/>
                            </EmailAddress>
                            <CorrespondenceLanguage>
                                <xsl:value-of select="DeliveryAddress/CorrespondenceLanguage"/>
                            </CorrespondenceLanguage>
                        </DeliveryAddress>
                        <!--                 Line   Attachments for 4BL-->
                        <xsl:if test="exists(Attachment)">
                            <xsl:for-each select="Attachment">
                                <Attachment>
                                    <xsl:attribute name="FileName">
                                        <xsl:value-of select="@FileName"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="FileSize">
                                        <xsl:value-of select="@FileSize"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="MimeType">
                                        <xsl:value-of select="@MimeType"/>
                                    </xsl:attribute>
                                    <xop:Include>
                                        <xsl:value-of select="namespace-uri(xop)"/>
                                        <xsl:attribute name="href">
                                            <xsl:value-of
                                                select="*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href"
                                            />
                                        </xsl:attribute>
                                    </xop:Include>
                                </Attachment>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:variable name="ancXMLLineAttachments">
                            <xsl:if
                                test="exists(/n0:RequestForQuotationS4Request/RequestForQuotation/RequestForQuotationItem/Attachment)">
                                <xsl:for-each
                                    select="/n0:RequestForQuotationS4Request/RequestForQuotation/RequestForQuotationItem/Attachment">
                                    <xsl:value-of
                                        select="concat(string-join((*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href, @FileName, @MimeType), ';'), '#')"
                                    />
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:variable>
                        <!--            Send the Fileanme to Platform, since MIME header from S4 doesn't send content/filename in the header. Format sent to platform.    
                cid:cidValue1#filename1|cid:cidvalid2#filename2-->
                        <xsl:variable name="ancXMLAttachments">
                            <xsl:value-of
                                select="concat($ancXMLAttachmentsHeader, $ancXMLLineAttachments)"/>
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($ancXMLAttachments)) &gt; 0">
                            <!--                            <an><xsl:value-of select="concat($ancXMLAttachmentsHeader, $ancXMLLineAttachments)"/></an>-->
                            
                        </xsl:if>
                        <ItemIncoterms>
                            <IncotermsClassification>
                                <xsl:value-of select="ItemIncoterms/IncotermsClassification"/>
                            </IncotermsClassification>
                            <IncotermsVersion>
                                <xsl:value-of select="ItemIncoterms/IncotermsVersion"/>
                            </IncotermsVersion>
                            <IncotermsLocation1>
                                <xsl:value-of select="ItemIncoterms/IncotermsLocation1"/>
                            </IncotermsLocation1>
                            <IncotermsLocation2>
                                <xsl:value-of select="ItemIncoterms/IncotermsLocation2"/>
                            </IncotermsLocation2>
                        </ItemIncoterms>
                        <xsl:for-each select="TextCollection">
                            <TextCollection>
                                <ContentText>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of select="ContentText/@languageCode"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ContentText"/>
                                </ContentText>
                                <TypeCode>
                                    <xsl:value-of select="TypeCode"/>
                                </TypeCode>
                                <MimeType>
                                    <xsl:value-of select="MimeType"/>
                                </MimeType>
                            </TextCollection>
                        </xsl:for-each>
                    </RequestForQuotationItem>
                </xsl:for-each>
            </RequestForQuotation>
        </n0:RequestForQuotationS4Request>
    </xsl:template>
</xsl:stylesheet>
