<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:param name="anISASender"/>
   <xsl:param name="anISASenderQual"/>
   <xsl:param name="anISAReceiver"/>
   <xsl:param name="anISAReceiverQual"/>
   <xsl:param name="anDate"/>
   <xsl:param name="anTime"/>
   <xsl:param name="anICNValue"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anSenderGroupID"/>
   <xsl:param name="anReceiverGroupID"/>
   <xsl:param name="exchange"/>
   <xsl:variable name="v_countSNP" select="count(/cXML/Request/ShipNoticeRequest/ShipNoticePortion)"/>
   <xsl:variable name="v_dateNow" select="current-dateTime()"/>
   <!-- For local testing -->
   <!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
   <!-- for dynamic, reading from Partner Directory -->
    <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

   <xsl:template match="/">
      <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
         <!-- create ISA -->
         <xsl:call-template name="createISA">
            <xsl:with-param name="dateNow" select="$v_dateNow"/>
         </xsl:call-template>
         <!-- create Functional Group -->
         <FunctionalGroup>
            <S_GS>
               <D_479>
                  <xsl:value-of select="'SW'"/>
               </D_479>
               <D_142>
                  <xsl:choose>
                     <xsl:when test="$anSenderGroupID != ''">
                        <xsl:value-of select="$anSenderGroupID"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="'ARIBA'"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_142>
               <D_124>
                  <xsl:choose>
                     <xsl:when test="$anReceiverGroupID != ''">
                        <xsl:value-of select="$anReceiverGroupID"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="'ARIBA'"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_124>
               <D_373>
                  <xsl:value-of select="format-dateTime($v_dateNow, '[Y0001][M01][D01]')"/>
               </D_373>
               <D_337>
                  <xsl:value-of select="format-dateTime($v_dateNow, '[H01][m01][s01]')"/>
               </D_337>
               <D_28>
                  <xsl:value-of select="$anICNValue"/>
               </D_28>
               <D_455>
                  <xsl:value-of select="'X'"/>
               </D_455>
               <D_480>
                  <xsl:value-of select="'004010'"/>
               </D_480>
            </S_GS>
            <!-- create Mssage 945 -->
            <M_945>
               <S_ST>
                  <D_143>
                     <xsl:value-of select="'945'"/>
                  </D_143>
                  <D_329>
                     <xsl:value-of select="'0001'"/>
                     <!-- auto. gen.? -->
                  </D_329>
               </S_ST>
               <!-- create Message Header W06 -->
               <S_W06>
                  <D_514>
                     <xsl:value-of select="'J'"/>
                  </D_514>
                  <xsl:if test="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate!=''">
                  <D_373>
                     <xsl:value-of
                        select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, '[Y0001][M01][D01]')"
                     />
                  </D_373>
                  </xsl:if>
                  <xsl:if test="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID!=''">
                  <D_145>
                     <xsl:value-of
                        select="substring(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID), 1, 30)"
                     />
                  </D_145>
                  </xsl:if>
                  <xsl:if
                     test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation)) > 0">
                     <D_306>
                        <xsl:variable name="v_operation"
                           select="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation"/>
                        <xsl:choose>
                           <xsl:when test="$v_operation = 'new'">
                              <xsl:value-of select="'17'"/>
                           </xsl:when>
                           <xsl:when test="$v_operation = 'delete'">
                              <xsl:value-of select="'3'"/>
                           </xsl:when>
                           <xsl:when test="$v_operation = 'update'">
                              <xsl:value-of select="'2'"/>
                           </xsl:when>
                        </xsl:choose>
                     </D_306>
                  </xsl:if>
               </S_W06>
               <!-- create 0100, N1-N4, PER / Parties, Communication -->
               <xsl:for-each select="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact">
                  <G_0100>
                     <xsl:call-template name="create_N1">
                        <xsl:with-param name="party" select="."/>
                     </xsl:call-template>
                  </G_0100>
               </xsl:for-each>
               <!-- create N9 / Reference - Order ID only if 1 <ShipNoticePortion> in the message, else map on item level -->
               <xsl:if test="$v_countSNP = 1">
                  <xsl:if
                     test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderID)) > 0">
                     <S_N9>
                        <D_128>
                           <xsl:value-of select="'PO'"/>
                        </D_128>
                        
                        <D_369>
                           <xsl:value-of
                              select="substring(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderID), 1, 45)"
                           />
                        </D_369>
                        
                        <xsl:if test="/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate!=''">
                        <D_373>
                           <xsl:value-of
                              select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate, '[Y0001][M01][D01]')"
                           />
                        </D_373>
                        </xsl:if>
                        <xsl:if test="/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate!=''">
                        <D_337>
                           <xsl:value-of
                              select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate, '[H01][m01][s01]')"
                           />
                        </D_337>
                        </xsl:if>
                        <xsl:variable name="v_timeZone"
                           select="replace(replace(substring(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                        <xsl:if
                           test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                        <D_623>
                              <xsl:value-of
                                 select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                              />
                        </D_623>
                        </xsl:if>
                     </S_N9>
                  </xsl:if>
               </xsl:if>
               <!-- System ID -->
               <xsl:if
                  test="string-length(normalize-space(/cXML/Header/From/Credential[@domain = 'SystemID']/Identity)) > 0">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'06'"/>
                     </D_128>
                     
                     <D_127>
                        <xsl:value-of
                           select="substring(normalize-space(/cXML/Header/From/Credential[@domain = 'SystemID']/Identity), 1, 30)"
                        />
                     </D_127>
                     
                  </S_N9>
               </xsl:if>
               <!-- Transport comments -->
               <xsl:if test="
                     /cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other'] and
                     /cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode = 'Transport Condition'">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'0L'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="'TransportComments'"/>
                     </D_127>
                     <xsl:if test="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments[@type = 'Transport']!=''">
                     <D_369>
                        <xsl:value-of
                           select="substring(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments[@type = 'Transport']), 1, 45)"
                        />
                     </D_369>
                     </xsl:if>
                  </S_N9>
               </xsl:if>
               <!-- Extrinsics -->
               <xsl:for-each select="/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name!=''][normalize-space(.)!='']">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'ZZ'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="substring(normalize-space(.), 1, 45)"/>
                     </D_369>
                  </S_N9>
               </xsl:for-each>
               <!-- ship notice date -->
               <xsl:if
                  test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'85'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, '[H01][m01][s01]')"
                        />
                     </D_337>
                     <xsl:variable name="v_timeZone"
                        select="replace(replace(substring(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                     <xsl:if
                        test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                     <D_623>
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                     </D_623>
                     </xsl:if>
                  </S_G62>
               </xsl:if>
               <!-- shipment date -->
               <xsl:if
                  test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'11'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate, '[H01][m01][s01]')"
                        />
                     </D_337>
                     <xsl:variable name="v_timeZone"
                        select="replace(replace(substring(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                     <xsl:if
                        test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                     <D_623>
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                     </D_623>
                     </xsl:if>
                  </S_G62>
               </xsl:if>
               <!-- delivery date -->
               <xsl:if
                  test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'02'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of
                           select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate, '[H01][m01][s01]')"
                        />
                     </D_337>
                     <xsl:variable name="v_timeZone"
                        select="replace(replace(substring(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                     <xsl:if
                        test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                     <D_623>
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                     </D_623>
                     </xsl:if>
                  </S_G62>
               </xsl:if>
               <!-- Transport comments -->
               <xsl:if test="
                     /cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other'] and
                     /cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode = 'Transport Condition'">
                  <xsl:variable name="v_shipPaymMethod"
                     select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
                  <xsl:if
                     test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $v_shipPaymMethod]/X12Code != ''">
                  <S_W27>
                     <D_91>ZZ</D_91>
                     <D_146>
                           <xsl:value-of
                              select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $v_shipPaymMethod]/X12Code"
                           />
                     </D_146>
                  </S_W27>
                  </xsl:if>
               </xsl:if>
               <!-- total of packages -->
               <xsl:if
                  test="string-length(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackages'])) > 0">
                  <S_W10>
                     <D_406>
                        <xsl:value-of
                           select="substring(normalize-space(/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackages']), 1, 3)"
                        />
                     </D_406>
                  </S_W10>
               </xsl:if>
               <!-- if we have packaging group them on "ShippingContainerSerialCode" and create a new group G_0300 for every new group-->
               <xsl:for-each-group
                  select="cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem"
                  group-by="Packaging[not(exists(ShippingContainerSerialCodeReference))]/ShippingContainerSerialCode">
                  
                  <xsl:variable name="packValue">
                     <xsl:value-of select="current-grouping-key()"/>
                  </xsl:variable>
                     <G_0300>
                        <S_LX>
                           <D_554>
                              <xsl:value-of select="position()"/>
                           </D_554>
                        </S_LX>
                        <S_MAN>
                           <D_88>
                              <xsl:value-of select="'GM'"/>
                           </D_88>
                           <D_87>                              
                              <xsl:value-of select="substring($packValue, 1, 48)"/>
                           </D_87>
                        </S_MAN>
                        <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/PackageID/PackageTrackingID">                        
                        <S_MAN>
                           <D_88>
                              <xsl:value-of select="'CA'"/>
                           </D_88>
                           <D_87>
                              <xsl:value-of select="substring(Packaging[ShippingContainerSerialCode = $packValue]/PackageID/PackageTrackingID, 1, 48)"/>
                           </D_87>
                        </S_MAN>
                        </xsl:if>
                        <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/PackageID/GlobalIndividualAssetID!=''">
                        <S_MAN>
                           <D_88>
                              <xsl:value-of select="'ZZ'"/>
                           </D_88>
                           <D_87>
                              <xsl:value-of select="'GIAI'"/>
                           </D_87>
                           <D_87_2>
                              <xsl:value-of
                                 select="substring(Packaging[ShippingContainerSerialCode = $packValue]/PackageID/GlobalIndividualAssetID, 1, 48)"/>
                           </D_87_2>
                        </S_MAN>
                        </xsl:if>
                        <!-- pallet info -->
                        <S_PAL>
                           <D_395>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'unitNetWeight']/@quantity"/>
                           </D_395>
                           <xsl:variable name="uom" select="normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'unitNetWeight']/UnitOfMeasure)"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code!=''">
                           <D_355>
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                           </D_355>
                           </xsl:if>
                           <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'length']/@quantity!=''">
                           <D_82>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'length']/@quantity"/>
                           </D_82>
                           </xsl:if>
                           <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'width']/@quantity!=''">
                           <D_189>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'width']/@quantity"/>
                           </D_189>
                           </xsl:if>
                           <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'height']/@quantity!=''">
                           <D_65>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'height']/@quantity"/>
                           </D_65>
                           </xsl:if>
                           <!-- [kishore:need to check on this not clear] whether check lookup for length, width and height for D_355_2?? -->
                           <xsl:variable name="uom_L" select="normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'length']/UnitOfMeasure)"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_L]/X12Code!=''">                           
                           <D_355_2>                              
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_L]/X12Code"/>
                           </D_355_2>
                           </xsl:if>
                           <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'grossWeight']/@quantity!=''">
                           <D_384>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'grossWeight']/@quantity"/>
                           </D_384>
                           </xsl:if>
                           <xsl:variable name="uom_g" select="normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'grossWeight']/UnitOfMeasure)"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_g]/X12Code!=''"> 
                           <D_355_3>
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_g]/X12Code"
                              />
                           </D_355_3>
                           </xsl:if>
                           <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'volume']/@quantity!=''">
                           <D_385>
                              <xsl:value-of select="Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'volume']/@quantity"/>
                           </D_385>
                           </xsl:if>
                           <xsl:variable name="uom_v" select="normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/Dimension[@type = 'volume']/UnitOfMeasure)"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_v]/X12Code!=''">
                           <D_355_4>
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom_v]/X12Code"/>
                           </D_355_4>
                           </xsl:if>
                        </S_PAL>
                        
                        <xsl:if test="Packaging[ShippingContainerSerialCode = $packValue]/PackagingCode!='' or Packaging[ShippingContainerSerialCode = $packValue]/PackageTypeCodeIdentifierCode!=''">
                        <S_N9>
                           <D_128>
                              <xsl:value-of select="'97'"/>
                           </D_128>
                           <D_127>
                              <xsl:value-of
                                 select="substring(normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/PackagingCode), 1, 30)"/>
                           </D_127>
                           <D_369>
                              <xsl:value-of
                                 select="substring(normalize-space(Packaging[ShippingContainerSerialCode = $packValue]/PackageTypeCodeIdentifierCode), 1, 45)"
                              />
                           </D_369>
                        </S_N9>
                        </xsl:if>
                        <!-- packaging code -->
                        <xsl:for-each select="current-group()">                           
                           <xsl:call-template name="createItem">
                              <xsl:with-param name="Package">
                                 <xsl:value-of select="'YES'"/>
                              </xsl:with-param>  
                              <xsl:with-param name="Path" select="Packaging[ShippingContainerSerialCode = current-grouping-key()]">                                 
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:for-each>
                     </G_0300>
               </xsl:for-each-group>
               
               <!-- lineCount -->
               <xsl:variable name="Packagecount">
                  <xsl:for-each-group
                     select="cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem"
                     group-by="Packaging[not(exists(ShippingContainerSerialCodeReference))]/ShippingContainerSerialCode">
                     <xsl:value-of select="concat(';',position())"/>
                  </xsl:for-each-group>
               </xsl:variable>
               <xsl:variable name="lineCount">
                  <xsl:choose>
                     <xsl:when test="$Packagecount!=''">
                        <xsl:value-of select="tokenize($Packagecount,';')[last()]"/> 
                     </xsl:when>
                     <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               
               <!-- no packaging, create only one group G_0300 for all no packaging line items -->
               <xsl:variable name="CountNoPackaging">
                  <xsl:value-of select="count(cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[not(exists(Packaging))])"/>
               </xsl:variable>
               <xsl:if test="$CountNoPackaging > 0">
                  <G_0300>
                     <S_LX>
                        <D_554>
                           <xsl:value-of select="$lineCount + 1"/>
                        </D_554>
                     </S_LX>
                     <xsl:for-each
                        select="cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[not(exists(Packaging))]">
                     <xsl:call-template name="createItem">
                        
                     </xsl:call-template>
                     </xsl:for-each>
                  </G_0300>
               </xsl:if>
               <S_SE>
                  <D_96>
                     <xsl:text>#segCount#</xsl:text>
                  </D_96>
                  <D_329>
                     <xsl:value-of select="'0001'"/>
                  </D_329>
               </S_SE>
            </M_945>
            <S_GE>
               <D_97>1</D_97>
               <D_28>
                  <xsl:value-of select="$anICNValue"/>
               </D_28>
            </S_GE>
         </FunctionalGroup>
         <S_IEA>
            <D_I16>1</D_I16>
            <D_I12>
               <xsl:value-of select="$anICNValue"/>
            </D_I12>
         </S_IEA>
      </ns0:Interchange>
   </xsl:template>


   <xsl:template name="createItem">
      <xsl:param name="Package"/>
      <xsl:param name="Path"/>
      <!-- item detail -->
      <G_0310>
         <S_W12>
            <D_368>
               <xsl:value-of select="'ZZ'"/>
            </D_368>
            <xsl:if test="OrderedQuantity/@quantity">
                     <D_330>
                        <xsl:value-of select="OrderedQuantity/@quantity"/>
                     </D_330>
            </xsl:if>
            
            <xsl:choose>
               <xsl:when test="$Package = 'YES'">
                  <xsl:if test="$Path/DispatchQuantity/@quantity!=''">
                  <D_382>
                     <xsl:value-of select="$Path/DispatchQuantity/@quantity"/>
                  </D_382>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:if test="@quantity!=''">
                  <D_382>
                     <xsl:value-of select="@quantity"/>
                  </D_382>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="$Package = 'YES'">                  
                  <xsl:variable name="uom" select="normalize-space($Path/DispatchQuantity/UnitOfMeasure)"/>
                  <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                  <D_355>
                  <xsl:choose>
                     <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                        <xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
                     </xsl:when>
                     <xsl:otherwise>ZZ</xsl:otherwise>
                  </xsl:choose>
                  </D_355>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="uom" select="normalize-space(UnitOfMeasure)"/>
                  <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                  <D_355>
                     <xsl:choose>
                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                           <xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
                        </xsl:when>
                        <xsl:otherwise>ZZ</xsl:otherwise>
                     </xsl:choose>
                  </D_355>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="ItemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier!=''">
               <D_438>
                  <xsl:value-of
                     select=" substring(ItemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier,1,12)"
                  />
               </D_438>
            </xsl:if>
            <!-- <D_235> and <D_234> -->            
            <xsl:call-template name="createItemPartsW12">
               <xsl:with-param name="itemDetail" select="."/>
               <xsl:with-param name="itemID" select="ItemID"/>
            </xsl:call-template>

         </S_W12>
         <!-- item detail description -->
         <xsl:if test="ShipNoticeItemDetail/Description!=''">
            <S_G69>
                     <D_369>
                        <xsl:value-of select="ShipNoticeItemDetail/Description"/>
                     </D_369>
            </S_G69>
         </xsl:if>



         <!-- order ID -->
         <xsl:if
            test="/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderID != '' and ($v_countSNP > 1)">
            <S_N9>
               <D_128>
                  <xsl:value-of select="'PO'"/>
               </D_128>          
                  <D_369>
                     <xsl:value-of
                        select="substring(normalize-space(../OrderReference/@orderID), 1, 45)"/>
                  </D_369>
                  <D_373>
                     <xsl:value-of
                        select="format-dateTime(../OrderReference/@orderDate, '[Y0001][M01][D01]')"
                     />
                  </D_373>
                  <D_337>
                     <xsl:value-of
                        select="format-dateTime(../OrderReference/@orderDate, '[H01][m01][s01]')"/>
                  </D_337>
                  <D_623>
                     <!--  <xsl:variable name="v_timeZone" select="format-dateTime(/cXML/Request/ShipNoticeRequest/ShipNoticePortion/OrderReference/@orderDate, '[Z]')"/>-->
                     <xsl:variable name="v_timeZone"
                        select="replace(replace(substring(../OrderReference/@orderDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                     <xsl:choose>
                        <xsl:when
                           test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                        </xsl:when>
                     </xsl:choose>
                  </D_623>
               
            </S_N9>
         </xsl:if>

         <!-- line nr. -->
         <xsl:if test="@lineNumber!=''">
            <S_N9>
               <D_128>
                  <xsl:value-of select="'LI'"/>
               </D_128>               
                     <D_127>
                        <xsl:value-of select="@lineNumber"/>
                     </D_127>
            </S_N9>
         </xsl:if>



         <!-- stock transfer type -->
         <xsl:if test="@stockTransferType!=''">
            <S_N9>
               <D_128>
                  <xsl:value-of select="'8X'"/>
               </D_128>
              
                     <D_127>
                        <xsl:value-of select="@outboundType"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="@stockTransferType"/>
                     </D_369>
            </S_N9>
         </xsl:if>

         <!-- Extrinsics -->
         
               <xsl:for-each select="Extrinsic[@name!='']">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'ZZ'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="@name"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="substring(normalize-space(.), 1, 45)"/>
                     </D_369>
                  </S_N9>
               </xsl:for-each>
            
         <!-- measurements -->
        
               <xsl:for-each select="ShipNoticeItemDetail/Dimension">
                  <xsl:variable name="v_MeasureCode" select="@type"/>
                  <xsl:variable name="v_UOMCodes" select="UnitOfMeasure"/>
                  <S_MEA>
                     <D_737>
                        <xsl:value-of select="'PD'"/>
                     </D_737>
                     <xsl:if
                        test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $v_MeasureCode]/X12Code != ''">
                     <D_738>
                           <xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $v_MeasureCode]/X12Code"/>
                     </D_738>
                     </xsl:if>
                     <xsl:if test="@quantity!=''">
                     <D_739>
                        <xsl:value-of select="@quantity"/>
                     </D_739>
                     </xsl:if>
                     <xsl:if
                        test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $v_UOMCodes]/X12Code != ''">
                     <C_C001>
                        <D_355>
                              <xsl:value-of
                                 select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $v_UOMCodes]/X12Code"
                              />
                           
                        </D_355>
                     </C_C001>
                     </xsl:if>
                  </S_MEA>
               </xsl:for-each>

         <!-- batch -->
         <!--         <xsl:if test="../Batch">-->
         <S_LS>
            <D_447>
               <xsl:value-of select="'LX'"/>
            </D_447>
         </S_LS>
         <xsl:for-each select="Batch">
            <G_0312>
               <S_LX>
                  <D_554>
                     <xsl:value-of select="position()"/>
                  </D_554>
               </S_LX>
               <xsl:if
                  test="string-length(normalize-space(SupplierBatchID)) > 0 or string-length(normalize-space(BuyerBatchID)) > 0">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'BT'"/>
                     </D_128>
                     <xsl:if test="string-length(normalize-space(SupplierBatchID)) > 0">
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(SupplierBatchID), 1, 30)"
                           />
                        </D_127>
                     </xsl:if>
                     <xsl:if test="string-length(normalize-space(BuyerBatchID)) > 0">
                        <D_369>
                           <xsl:value-of select="substring(normalize-space(BuyerBatchID), 1, 45)"/>
                        </D_369>
                     </xsl:if>
                  </S_N9>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@originCountryCode)) > 0">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'BT'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="'originCountryCode'"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="substring(normalize-space(@originCountryCode), 1, 45)"
                        />
                     </D_369>
                  </S_N9>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@batchQuantity)) > 0">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'BT'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="'batchQuantity'"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="substring(normalize-space(@batchQuantity), 1, 45)"/>
                     </D_369>
                  </S_N9>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@shelfLife)) > 0">
                  <S_N9>
                     <D_128>
                        <xsl:value-of select="'BT'"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="'shelfLife'"/>
                     </D_127>
                     <D_369>
                        <xsl:value-of select="substring(normalize-space(@shelfLife), 1, 45)"/>
                     </D_369>
                  </S_N9>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@productionDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'BL'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of select="format-dateTime(@productionDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of select="format-dateTime(@productionDate, '[H01][m01][s01]')"/>
                     </D_337>
                     <D_623>
                        <xsl:variable name="v_timeZone"
                           select="replace(replace(substring(@productionDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                        <!--                       <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code"/>-->
                        <xsl:if
                           test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                        </xsl:if>
                     </D_623>
                  </S_G62>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@expirationDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'36'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of select="format-dateTime(@expirationDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of select="format-dateTime(@expirationDate, '[H01][m01][s01]')"/>
                     </D_337>
                     <D_623>
                        <xsl:variable name="v_timeZone"
                           select="replace(replace(substring(@expirationDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                        <!--                     <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code"/>-->
                        <xsl:if
                           test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                        </xsl:if>
                     </D_623>
                  </S_G62>
               </xsl:if>
               <xsl:if test="string-length(normalize-space(@inspectionDate)) > 0">
                  <S_G62>
                     <D_432>
                        <xsl:value-of select="'BI'"/>
                     </D_432>
                     <D_373>
                        <xsl:value-of select="format-dateTime(@inspectionDate, '[Y0001][M01][D01]')"
                        />
                     </D_373>
                     <D_176>
                        <xsl:value-of select="'W'"/>
                     </D_176>
                     <D_337>
                        <xsl:value-of select="format-dateTime(@inspectionDate, '[H01][m01][s01]')"/>
                     </D_337>
                     <D_623>
                        <xsl:variable name="v_timeZone"
                           select="replace(replace(substring(@inspectionDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                        <!--                     <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code"/>-->
                        <xsl:if
                           test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone]/X12Code != ''">
                           <xsl:value-of
                              select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $v_timeZone][1]/X12Code"
                           />
                        </xsl:if>
                     </D_623>
                  </S_G62>
               </xsl:if>
            </G_0312>
         </xsl:for-each>
         <!--</xsl:if>-->
         <S_LE>
            <D_447>LX</D_447>
         </S_LE>
      </G_0310>
   </xsl:template>


   <xsl:template name="create_N1">
      <xsl:param name="party"/>
      <xsl:variable name="v_role">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code != ''">
               <xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'ZZ'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <S_N1>
         <D_98>
            <xsl:value-of select="$v_role"/>
         </D_98>
         <D_93>
            <xsl:choose>
               <xsl:when test="string-length(normalize-space($party/Name)) > 0">
                  <xsl:value-of select="substring(normalize-space($party/Name), 1, 60)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="'Not Available'"/>
               </xsl:otherwise>
            </xsl:choose>
         </D_93>
         <xsl:variable name="v_addrDomain" select="$party/@addressIDDomain"/>
         <xsl:if test="string-length(normalize-space($party/@addressID)) > 1">
            <D_66>
               <xsl:if
                  test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $v_addrDomain]/X12Code != ''">
                  <xsl:value-of
                     select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $v_addrDomain]/X12Code"
                  />
               </xsl:if>
            </D_66>
            <D_67>
               <xsl:value-of select="substring(normalize-space($party/@addressID), 1, 80)"/>
            </D_67>
         </xsl:if>
      </S_N1>
      <!-- DeliverTo logic changed -->
      <xsl:variable name="v_delTo">
         <DeliverToList>
            <xsl:for-each select="$party/PostalAddress/DeliverTo">
               <xsl:if test="normalize-space(.) != ''">
                  <DeliverToItem>
                     <xsl:value-of select="substring(normalize-space(.), 0, 60)"/>
                  </DeliverToItem>
               </xsl:if>
            </xsl:for-each>
         </DeliverToList>
      </xsl:variable>
      <xsl:variable name="v_delToCount" select="count($v_delTo/DeliverToList/DeliverToItem)"/>
      <xsl:choose>
         <xsl:when test="$v_delToCount = 1">
            <S_N2>
               <D_93>
                  <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 1, 60)"/>
               </D_93>
               <xsl:if
                  test="substring(normalize-space($party/PostalAddress/DeliverTo), 60, 60) != ''">
                  <D_93_2>
                     <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 60, 60)"/>
                  </D_93_2>
               </xsl:if>
            </S_N2>
            <!--<xsl:if test="substring(normalize-space($party/PostalAddress/DeliverTo), 120, 60) != ''">
                  <S_N2>
                     <D_93>
                        <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 120, 60)"/>
                     </D_93>
                     <xsl:if
                        test="substring(normalize-space($party/PostalAddress/DeliverTo), 180, 60) != ''">
                        <D_93_2>
                           <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 180, 60)"/>
                        </D_93_2>
                     </xsl:if>
                  </S_N2>
               </xsl:if>-->
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="$v_delToCount = 1">
                  <!-- death code? -->
                  <S_N2>
                     <D_93>
                        <xsl:value-of select="$v_delTo/DeliverToList/DeliverToItem[1]"/>
                     </D_93>
                  </S_N2>
               </xsl:when>
               <xsl:when test="$v_delToCount > 1">
                  <S_N2>
                     <D_93>
                        <xsl:value-of select="$v_delTo/DeliverToList/DeliverToItem[1]"/>
                     </D_93>
                     <D_93_2>
                        <xsl:value-of select="$v_delTo/DeliverToList/DeliverToItem[2]"/>
                     </D_93_2>
                  </S_N2>
               </xsl:when>
               <!--<xsl:when test="$delToCount = 3">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
                        </D_93_2>
                     </S_N2>
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
                        </D_93>
                     </S_N2>
                  </xsl:when>
                  <xsl:when test="$delToCount > 3">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
                        </D_93_2>
                     </S_N2>
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[4]"/>
                        </D_93_2>
                     </S_N2>
                  </xsl:when>-->
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
      <!-- Street logic changed -->
      <xsl:variable name="v_street">
         <StreetList>
            <xsl:for-each select="$party/PostalAddress/Street">
               <xsl:if test="normalize-space(.) != ''">
                  <StreetItem>
                     <xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
                  </StreetItem>
               </xsl:if>
            </xsl:for-each>
         </StreetList>
      </xsl:variable>
      <xsl:variable name="v_streetCount" select="count($v_street/StreetList/StreetItem)"/>
      <xsl:choose>
         <xsl:when test="$v_streetCount = 1">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[1]"/>
               </D_166>
            </S_N3>
         </xsl:when>
         <xsl:when test="$v_streetCount = 2">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
         </xsl:when>
         <xsl:when test="$v_streetCount = 3">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[3]"/>
               </D_166>
            </S_N3>
         </xsl:when>
         <xsl:when test="$v_streetCount > 3">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
            <S_N3>
               <D_166>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[3]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$v_street/StreetList/StreetItem[4]"/>
               </D_166_2>
            </S_N3>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="
            string-length(normalize-space($party/PostalAddress/City)) > 0 or string-length(normalize-space($party/PostalAddress/State)) > 0 or
            string-length(normalize-space($party/PostalAddress/PostalCode)) > 0 or string-length(normalize-space($party/PostalAddress/Country/@isoCountryCode)) > 0">
         <S_N4>
            <xsl:if test="string-length(normalize-space($party/PostalAddress/City)) > 1">
               <D_19>
                  <xsl:value-of
                     select="substring(normalize-space($party/PostalAddress/City), 1, 30)"/>
               </D_19>
            </xsl:if>
            <xsl:variable name="v_uscaStateCode">
               <!-- new logic isoStateCode? backward comp. -->
               <xsl:if test="
                     ($party/PostalAddress/Country/@isoCountryCode = 'US' or $party/PostalAddress/Country/@isoCountryCode = 'CA') and
                     string-length(normalize-space($party/PostalAddress/State)) > 0 and string-length(normalize-space($party/PostalAddress/State/@isoStateCode)) > 0">
                  <xsl:variable name="v_stCode" select="normalize-space($party/PostalAddress/State)"/>
                  <xsl:choose>
                     <xsl:when
                        test="string-length(normalize-space($party/PostalAddress/State/@isoStateCode)) > 0">
                        <xsl:value-of select="$party/PostalAddress/State/@isoStateCode"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/States/State[stateName = $v_stCode]/stateCode != ''">
                              <xsl:value-of
                                 select="$Lookup/Lookups/States/State[stateName = $v_stCode]/stateCode"
                              />
                           </xsl:when>
                           <xsl:when test="string-length($v_stCode) = 2">
                              <xsl:value-of select="upper-case($v_stCode)"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($v_uscaStateCode)) > 0">
               <D_156>
                  <xsl:value-of select="$v_uscaStateCode"/>
               </D_156>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($party/PostalAddress/PostalCode)) > 2">
               <D_116>
                  <xsl:value-of
                     select="substring(normalize-space($party/PostalAddress/PostalCode), 1, 15)"/>
               </D_116>
            </xsl:if>
            <xsl:if test="$party/PostalAddress/Country/@isoCountryCode != ''">
               <D_26>
                  <!-- lookup? -->
                  <xsl:value-of select="$party/PostalAddress/Country/@isoCountryCode"/>
               </D_26>
            </xsl:if>
            <xsl:if
               test="$v_uscaStateCode = '' and normalize-space($party/PostalAddress/State) != ''">
               <D_309>
                  <xsl:value-of select="'SP'"/>
               </D_309>
               <D_310>
                  <xsl:value-of
                     select="substring(normalize-space($party/PostalAddress/State), 1, 30)"/>
               </D_310>
            </xsl:if>
         </S_N4>
      </xsl:if>
      <!-- create PER segment -->
      <xsl:call-template name="createPER">
         <xsl:with-param name="party" select="$party"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="createPER">
      <xsl:param name="party"/>
      <!--      <xsl:variable name="contactType">
         <xsl:value-of select="name($party)"/>
      </xsl:variable>-->
      <xsl:variable name="contactList">
         <xsl:apply-templates select="$party//Email"/>
         <xsl:apply-templates select="$party//Phone"/>
         <xsl:apply-templates select="$party//Fax"/>
         <xsl:apply-templates select="$party//URL"/>
      </xsl:variable>
      <xsl:for-each-group select="$contactList/Con" group-by="./@name">
         <xsl:sort select="@name"/>
         <xsl:variable name="v_PER02" select="current-grouping-key()"/>
         <xsl:for-each-group select="current-group()" group-by="(position() - 1) idiv 3">
            <S_PER>
               <D_366>
                  <xsl:value-of select="'IC'"/>
               </D_366>
               <D_93>
                  <xsl:value-of select="$v_PER02"/>
               </D_93>
               <xsl:for-each select="current-group()">
                  <xsl:choose>
                     <xsl:when test="(position() mod 4) = 1">
                        <D_365>
                           <xsl:value-of select="./@type"/>
                        </D_365>
                        <D_364>
                           <xsl:value-of select="."/>
                        </D_364>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:element name="{concat('D_365_', position() mod 4)}">
                           <xsl:value-of select="./@type"/>
                        </xsl:element>
                        <xsl:element name="{concat('D_364_', position() mod 4)}">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
            </S_PER>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:template>

   <xsl:template name="createItemPartsW12">
      <xsl:param name="itemID"/>
      <xsl:param name="itemDetail"/>
      <xsl:variable name="v_partsList">
         <PartsList>
            <xsl:if test="normalize-space($itemID/SupplierPartID) != ''">
               <Part>
                  <Qualifier>
                     <xsl:value-of select="'VP'"/>
                  </Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($itemID/SupplierPartID), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="normalize-space($itemID/BuyerPartID) != ''">
               <Part>
                  <Qualifier>
                     <xsl:value-of select="'BP'"/>
                  </Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($itemID/BuyerPartID), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>

            <xsl:if test="$itemDetail">
               <xsl:choose>
                  <xsl:when
                     test="normalize-space($itemDetail/ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                     <Part>
                        <Qualifier>
                           <xsl:value-of select="'EN'"/>
                        </Qualifier>
                        <Value>
                           <xsl:value-of
                              select="substring(normalize-space($itemDetail/ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 48)"
                           />
                        </Value>
                     </Part>
                  </xsl:when>
                  <xsl:when
                     test="normalize-space($itemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                     <Part>
                        <Qualifier>
                           <xsl:value-of select="'EN'"/>
                        </Qualifier>
                        <Value>
                           <xsl:value-of
                              select="substring(normalize-space($itemID/IdReference[@domain = 'EAN-13']/@identifier), 1, 48)"
                           />
                        </Value>
                     </Part>
                  </xsl:when>
               </xsl:choose>
            </xsl:if>
         </PartsList>
      </xsl:variable>
      <xsl:for-each select="$v_partsList/PartsList/Part">
         <xsl:choose>
            <xsl:when test="position() = 1">
               <D_235>
                  <xsl:value-of select="./Qualifier"/>
               </D_235>
               <D_234>
                  <xsl:value-of select="./Value"/>
               </D_234>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="{concat('D_235', '_', position())}">
                  <xsl:value-of select="./Qualifier"/>
               </xsl:element>
               <xsl:element name="{concat('D_234', '_', position())}">
                  <xsl:value-of select="./Value"/>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>
