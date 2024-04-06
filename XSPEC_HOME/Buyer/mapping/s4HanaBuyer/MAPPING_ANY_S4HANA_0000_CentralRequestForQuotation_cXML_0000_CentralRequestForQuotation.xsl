<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:hci="http://sap.com/it/"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="exchange"/>
    <xsl:template match="n0:CentralRequestForQuotationS4Request">
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
                <Origin>
                    <xsl:value-of select="'CS'"/>
                </Origin>
                <!--                Adding Action Code for Cancellation use case for 4BL and 4QN - IG-32617 CI-2218 -->
                <ActionCode>
                    <xsl:value-of select="CentralRequestForQuotation/ActionCode"/>
                </ActionCode>
            </MessageHeader>
            <RequestForQuotation>
                <RequestForQuotationID>
                    <xsl:value-of select="CentralRequestForQuotation/RequestForQuotationID"/>
                </RequestForQuotationID>
                <RequestForQuotationName>
                    <xsl:value-of select="CentralRequestForQuotation/RequestForQuotationName"/>
                </RequestForQuotationName>
                <RFQDocumentType>
                    <xsl:value-of select="CentralRequestForQuotation/RFQDocumentType"/>
                </RFQDocumentType>
                <Language>
                    <xsl:value-of select="CentralRequestForQuotation/Language"/>
                </Language>
                <CreationDate>
                    <xsl:value-of select="CentralRequestForQuotation/CreationDate"/>
                </CreationDate>
                <RFQPublishingDate>
                    <xsl:value-of select="CentralRequestForQuotation/RFQPublishingDate"/>
                </RFQPublishingDate>
                <QuotationLatestSubmissionDate>
                    <xsl:value-of select="CentralRequestForQuotation/QuotationLatestSubmissionDate"/>
                </QuotationLatestSubmissionDate>
                <BindingPeriodEndDate>
                    <xsl:value-of select="CentralRequestForQuotation/BindingPeriodEndDate"/>
                </BindingPeriodEndDate>
                <LatestRegistrationDate>
                    <xsl:value-of select="CentralRequestForQuotation/LatestRegistrationDate"/>
                </LatestRegistrationDate>
                <DocumentCurrency>
                    <xsl:value-of select="CentralRequestForQuotation/DocumentCurrency"/>
                </DocumentCurrency>
                <CompanyCode>
                    <xsl:value-of select="CentralRequestForQuotation/CompanyCode"/>
                </CompanyCode>
                <PurchasingOrganization>
                    <xsl:value-of select="CentralRequestForQuotation/PurchasingOrganization"/>
                </PurchasingOrganization>
                <PurchasingGroup>
                    <xsl:value-of select="CentralRequestForQuotation/PurchasingGroup"/>
                </PurchasingGroup>               
                    <HeaderIncoterms>
                        <IncotermsClassification>
                            <xsl:value-of
                                select="CentralRequestForQuotation/HeaderIncoterms/IncotermsClassification"
                            />
                        </IncotermsClassification>
                        <IncotermsVersion>
                            <xsl:value-of
                                select="CentralRequestForQuotation/HeaderIncoterms/IncotermsVersion"/>
                        </IncotermsVersion>
                        <IncotermsLocation1>
                            <xsl:value-of
                                select="CentralRequestForQuotation/HeaderIncoterms/IncotermsLocation1"/>
                        </IncotermsLocation1>
                        <IncotermsLocation2>
                            <xsl:value-of
                                select="CentralRequestForQuotation/HeaderIncoterms/IncotermsLocation2"/>
                        </IncotermsLocation2>
                    </HeaderIncoterms>              
                <FollowOnDocumentType>
                    <xsl:value-of select="CentralRequestForQuotation/FollowOnDocumentType"/>
                </FollowOnDocumentType>
                <FollowOnDocumentCategory>
                    <xsl:value-of select="CentralRequestForQuotation/FollowOnDocumentCategory"/>
                </FollowOnDocumentCategory>
                <xsl:for-each select="CentralRequestForQuotation/RFQBidder">
                    <RFQBidder>
                        <Supplier>
                            <xsl:value-of select="Supplier"/>
                        </Supplier>
                    </RFQBidder>
                </xsl:for-each>
                <SupplierSelectorMatchingType>
                    <xsl:value-of select="CentralRequestForQuotation/SupplierSelectorMatchingType"/>
                </SupplierSelectorMatchingType>
                <EmployeeResponsible>
                    <Employee>
                        <xsl:value-of select="CentralRequestForQuotation/EmployeeResponsible/Employee"/>
                    </Employee>
                    <Address>
                        <FormOfAddress>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/FormOfAddress"
                            />
                        </FormOfAddress>
                        <FormOfAddressName>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/FormOfAddressName"
                            />
                        </FormOfAddressName>
                        <FullName>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/FullName"/>
                        </FullName>
                        <StreetName>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/StreetName"
                            />
                        </StreetName>
                        <HouseNumber>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/HouseNumber"
                            />
                        </HouseNumber>
                        <PostalCode>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/PostalCode"
                            />
                        </PostalCode>
                        <CityName>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/CityName"/>
                        </CityName>
                        <Country>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/Country"/>
                        </Country>
                        <Region>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/Region"/>
                        </Region>
                        <District>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/District"/>
                        </District>
                        <County>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/County"/>
                        </County>
                        <Building>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/Building"/>
                        </Building>
                        <Floor>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/Floor"/>
                        </Floor>
                        <RoomNumber>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/RoomNumber"
                            />
                        </RoomNumber>
                        <FormattedPhoneNumber>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/FormattedPhoneNumber"
                            />
                        </FormattedPhoneNumber>
                        <PhoneNumber>
                            <AreaID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/AreaID"
                                />
                            </AreaID>
                            <SubscriberID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/SubscriberID"
                                />
                            </SubscriberID>
                            <ExtensionID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/ExtensionID"
                                />
                            </ExtensionID>
                            <CountryCode>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryCode"
                                />
                            </CountryCode>
                            <CountryDiallingCode>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryDiallingCode"
                                />
                            </CountryDiallingCode>
                            <CountryName>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of
                                        select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryName/@languageCode"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/PhoneNumber/CountryName"
                                />
                            </CountryName>
                        </PhoneNumber>
                        <FormattedFaxNumber>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/FormattedFaxNumber"
                            />
                        </FormattedFaxNumber>
                        <FaxNumber>
                            <AreaID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/AreaID"
                                />
                            </AreaID>
                            <SubscriberID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/SubscriberID"
                                />
                            </SubscriberID>
                            <ExtensionID>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/ExtensionID"
                                />
                            </ExtensionID>
                            <CountryCode>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryCode"
                                />
                            </CountryCode>
                            <CountryDiallingCode>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryDiallingCode"
                                />
                            </CountryDiallingCode>
                            <CountryName>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of
                                        select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryName/@languageCode"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="CentralRequestForQuotation/EmployeeResponsible/Address/FaxNumber/CountryName"
                                />
                            </CountryName>
                        </FaxNumber>
                        <EmailAddress>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/EmailAddress"
                            />
                        </EmailAddress>
                        <CorrespondenceLanguage>
                            <xsl:value-of
                                select="CentralRequestForQuotation/EmployeeResponsible/Address/CorrespondenceLanguage"
                            />
                        </CorrespondenceLanguage>
                    </Address>
                </EmployeeResponsible>
                <xsl:for-each select="CentralRequestForQuotation/TextCollection">
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
                <!--                    Attachments for 4QN 2108-->
                <xsl:if test="exists(CentralRequestForQuotation/Attachment)">
                    <xsl:for-each select="CentralRequestForQuotation/Attachment">
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
                    <xsl:for-each select="CentralRequestForQuotation/Attachment">
                        <xsl:value-of
                            select="concat(string-join((*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href, @FileName, @MimeType), ';'), '#')"
                        />
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="CentralRequestForQuotation/RequestForQuotationItem">
                    <RequestForQuotationItem>
                        <RequestForQuotationItemID>
                            <xsl:value-of select="RequestForQuotationItemID"/>
                        </RequestForQuotationItemID>
                        <PurchasingDocumentItemText>
                            <xsl:value-of select="PurchasingDocumentItemText"/>
                        </PurchasingDocumentItemText>
                        <Plant>
                            <xsl:value-of select="CentralRFQItmDistribution/Plant "/>
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
<!--                        Begin of Change   CI-1723 - Enabling Lean Services           -->
                        <StartDate>
                            <xsl:value-of select="PerformancePeriodStartDate"/>
                        </StartDate>
                        <EndDate>
                            <xsl:value-of select="PerformancePeriodEndDate"/>
                        </EndDate>
                        <ItemType>
                            <xsl:if test="ProductType = '1'">Item</xsl:if>
                            <xsl:if test="ProductType = '2'">Lean</xsl:if>
                        </ItemType>
                        <ItemClassification>
                            <xsl:if test="ProductType = '1'">Material</xsl:if>
                            <xsl:if test="ProductType = '2'">Service</xsl:if>
                        </ItemClassification>
<!--                        End of Change   CI-1723 - Enabling Lean Services                  -->
                        <DeliveryAddress>
                            <FormOfAddress>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FormOfAddress"/>
                            </FormOfAddress>
                            <FormOfAddressName>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FormOfAddressName"/>
                            </FormOfAddressName>
                            <FullName>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FullName"/>
                            </FullName>
                            <StreetName>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/StreetName"/>
                            </StreetName>
                            <HouseNumber>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/HouseNumber"/>
                            </HouseNumber>
                            <PostalCode>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PostalCode"/>
                            </PostalCode>
                            <CityName>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/CityName"/>
                            </CityName>
                            <Country>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/Country"/>
                            </Country>
                            <Region>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/Region"/>
                            </Region>
                            <District>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/District"/>
                            </District>
                            <County>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/County"/>
                            </County>
                            <Building>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/Building"/>
                            </Building>
                            <Floor>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/Floor"/>
                            </Floor>
                            <RoomNumber>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/RoomNumber"/>
                            </RoomNumber>
                            <FormattedPhoneNumber>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FormattedPhoneNumber"/>
                            </FormattedPhoneNumber>
                            <PhoneNumber>
                                <AreaID>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/AreaID"/>
                                </AreaID>
                                <SubscriberID>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/SubscriberID"
                                    />
                                </SubscriberID>
                                <ExtensionID>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/ExtensionID"/>
                                </ExtensionID>
                                <CountryCode>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/CountryCode"/>
                                </CountryCode>
                                <CountryDiallingCode>
                                    <xsl:value-of
                                        select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/CountryDiallingCode"/>
                                </CountryDiallingCode>
                                <CountryName>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of
                                            select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/CountryName/@languageCode"
                                        />
                                    </xsl:attribute>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/PhoneNumber/CountryName"/>
                                </CountryName>
                            </PhoneNumber>
                            <FormattedFaxNumber>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FormattedFaxNumber"/>
                            </FormattedFaxNumber>
                            <FaxNumber>
                                <AreaID/>
                                <SubscriberID>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/AreaID"/>
                                </SubscriberID>
                                <ExtensionID>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/ExtensionID"/>
                                </ExtensionID>
                                <CountryCode>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/CountryCode"/>
                                </CountryCode>
                                <CountryDiallingCode>
                                    <xsl:value-of
                                        select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/CountryDiallingCode"/>
                                </CountryDiallingCode>
                                <CountryName>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of
                                            select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/CountryName/@languageCode"
                                        />
                                    </xsl:attribute>
                                    <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/FaxNumber/CountryName"/>
                                </CountryName>
                            </FaxNumber>
                            <EmailAddress>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/EmailAddress"/>
                            </EmailAddress>
                            <CorrespondenceLanguage>
                                <xsl:value-of select="CentralRFQItmDistribution/DeliveryAddress/CorrespondenceLanguage"/>
                            </CorrespondenceLanguage>
                        </DeliveryAddress>
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
                        <!--                 Line   Attachments for 4QN 2108-->
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
                    </RequestForQuotationItem>
                </xsl:for-each>
                <xsl:variable name="ancXMLLineAttachments">
                    <xsl:if
                        test="exists(/n0:CentralRequestForQuotationS4Request/CentralRequestForQuotation/RequestForQuotationItem/Attachment)">
                        <xsl:for-each
                            select="/n0:CentralRequestForQuotationS4Request/CentralRequestForQuotation/RequestForQuotationItem/Attachment">
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
<!--                    <an><xsl:value-of select="concat($ancXMLAttachmentsHeader, $ancXMLLineAttachments)"/></an>-->
                     
                </xsl:if>               
            </RequestForQuotation>
        </n0:RequestForQuotationS4Request>
    </xsl:template>
</xsl:stylesheet>
