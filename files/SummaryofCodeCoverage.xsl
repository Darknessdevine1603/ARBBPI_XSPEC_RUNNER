<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="fileSperator"/>
    <xsl:param name="DateRun"/>
    <xsl:template match="CoverageReportSummary">
        <xsl:variable name="v_xspecFileSeparator">
            <xsl:value-of select="concat($fileSperator, 'xspec', $fileSperator)"/>
        </xsl:variable>
        <html>
            <head>
                <style>
                    table,
                    th,
                    td {
                        border: 1px solid black;
                    }</style>
            </head>
            <title>Summary of Coverage Report</title>
            <!--                        <img src="SAP_Ariba.png" style="position:relative; top:0; left:0;' width='50' height='50' alt=''"/>-->

            <body>


                <h2 style="font-family:arial;font-weight: bold;color: navy;">
                    <p style="float: left;">XSLT Code Coverage Reports Summary</p>
                    <p style="float: right;">
                        <xsl:value-of select="concat('Coverage Report Executed on : ', $DateRun)"/>
                    </p>
                </h2>
                <h3 style="font-family:arial;font-weight: bold;clear: both;color: mediumblue;">
                    <xsl:value-of select="concat('Number of XSLTs Mappings : ', TotalMaps)"/>
                </h3>
                <h3 style="font-family:arial;font-weight: bold;font-weight: italic;color: mediumblue;">
                    <xsl:value-of
                        select="concat('Number of XSPECs : ', count(SummaryCoverage/moduleName))"/>
                </h3>
                <h4 style="font-family:arial;font-weight: italic; color:mediumblue;">
                    <xsl:value-of
                        select="concat('Total Lines in XSLT Mappings : ', TotalExecutedLines + MissedLines)"/>
                </h4>
                <h4 style="font-family:arial;font-weight: italic;color:mediumblue;">
                    <xsl:value-of select="concat('Executed Lines : ', TotalExecutedLines)"/>
                </h4>
                <h3 style="font-family:arial;font-weight: italic;color: blue;">
                    <xsl:value-of
                        select="concat('Overall Code Coverage : ', format-number(TotalExecutedLines div (TotalExecutedLines + MissedLines) * 100, '00.00'), '%')"/>
                </h3>
                <h5 style="font-family:arial;font-weight: italic">Click on the Map name to view the
                    Code Coverage Report</h5>

                <table>
                    <tr>

                        <th style="font-family:arial;font-weight: bold">Module Name</th>
                        <th style="font-family:arial;font-weight: bold">Map Name</th>
                        <!--<th style="font-family:arial;font-weight: bold">TotalLines</th>-->
                        <th style="font-family:arial;font-weight: bold">Coverage</th>
                        <th style="font-family:arial;font-weight: bold"/>
                        <th style="font-family:arial;font-weight: bold">Passed Scenarios</th>
                        <th style="font-family:arial;font-weight: bold">Failed Scenarios</th>

                    </tr>
                    <tr>

                        <td
                            style="font-weight: bold;background-color:gold;text-align:center;text-orientation: upright;font-family:verdana">
                            <xsl:attribute name="rowspan">
                                <xsl:value-of select="count(SummaryCoverage/moduleName) + 1"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'anBuyer'">SAP Ariba
                                    Network Buyer</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'anSupplier'">SAP Ariba
                                    Network Supplier</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'p2p'">SAP Ariba
                                    Procurement</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 's4'">SAP Ariba
                                    Sourcing</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 's4HanaBuyer'">SAP
                                    Ariba Network S4 HANA Buyer</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 's4HanaSupplier'">SAP
                                    Ariba Network S4 HANA Supplier</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'CIM'">Central Invoice Management</xsl:when>
                            </xsl:choose>
                             <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'eTender'">eTendering</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'fieldglass'">SAP
                                    Fieldglass</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'BIS'">Business
                                    Integration Suite</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'EANCOM_D01B'">United
                                    Nations Electronic Data Interchange for Administration, Commerce
                                    and Transport Version D01</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'EANCOM_D96A'">United
                                    Nations Electronic Data Interchange for Administration, Commerce
                                    and Transport Version D96A</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'EDIFACT_D01B'"
                                    >Electronic Data Interchange for Administration, Commerce and
                                    Transport Version D01B</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'EDIFACT_D96A'"
                                    >Electronic Data Interchange for Administration, Commerce and
                                    Transport Version D96A</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'GUSI'">Global Upstream
                                    Supply Initiative</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'OAGIS'">Open
                                    Applications Group Integration Specification </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'PIDX'">Petroleum
                                    Industry Data Exchange</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'X12'">Accredited
                                    Standards Committee X12</xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="SummaryCoverage/moduleName = 'xCBL'">Common Business
                                    Library</xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>

                    <xsl:for-each select="SummaryCoverage">
                        <xsl:sort select="Coverage - 1" order="descending"/>
                        <tr>

                            <td>
                                <xsl:attribute name="style">
                                    <xsl:choose>
                                        <xsl:when test="Coverage &lt; 50">
                                            <xsl:value-of
                                                select="'background-color:red;font-family:verdana;'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 60 or Coverage = 60) and Coverage &gt; 50">
                                            <xsl:value-of
                                                select="'background-color:orange;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 70 or Coverage = 70) and Coverage &gt; 60">
                                            <xsl:value-of
                                                select="'background-color:yellow;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 80 or Coverage = 80) and Coverage &gt; 70">
                                            <xsl:value-of
                                                select="'background-color:cyan;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 85 or Coverage = 85) and Coverage &gt; 80">
                                            <xsl:value-of
                                                select="'background-color:lightseagreen;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 90 or Coverage = 90) and Coverage &gt; 85">
                                            <xsl:value-of
                                                select="'background-color:springgreen;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 95 or Coverage = 95) and Coverage &gt; 90">
                                            <xsl:value-of
                                                select="'background-color:lime;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when test="Coverage &gt; 95">
                                            <xsl:value-of
                                                select="'background-color:green;font-family:verdana'"
                                            />
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>

                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="file"/>
                                    </xsl:attribute>

                                    <xsl:if test="Coverage &lt; 50 or Coverage &gt; 95">
                                        <xsl:attribute name="style">
                                            <xsl:value-of select="'color:white;'"/>
                                        </xsl:attribute>
                                    </xsl:if>

                                    <xsl:value-of
                                        select="substring-before(substring-after(file, $v_xspecFileSeparator), '-CodeCoverageStats.html')"/>
                                    <!--                                    <xsl:value-of select="file"/>-->
                                </a>
                            </td>

                            <td style="font-family:verdana">
                                <xsl:attribute name="style">
                                    <xsl:choose>
                                        <xsl:when test="Coverage &lt; 50">
                                            <xsl:value-of
                                                select="'background-color:red;font-family:verdana;color:white'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 60 or Coverage = 60) and Coverage &gt; 50">
                                            <xsl:value-of
                                                select="'background-color:orange;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 70 or Coverage = 70) and Coverage &gt; 60">
                                            <xsl:value-of
                                                select="'background-color:yellow;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 80 or Coverage = 80) and Coverage &gt; 70">
                                            <xsl:value-of
                                                select="'background-color:cyan;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 85 or Coverage = 85) and Coverage &gt; 80">
                                            <xsl:value-of
                                                select="'background-color:lightseagreen;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 90 or Coverage = 90) and Coverage &gt; 85">
                                            <xsl:value-of
                                                select="'background-color:springgreen;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="(Coverage &lt; 95 or Coverage = 95) and Coverage &gt; 90">
                                            <xsl:value-of
                                                select="'background-color:lime;font-family:verdana'"
                                            />
                                        </xsl:when>
                                        <xsl:when test="Coverage &gt; 95">
                                            <xsl:value-of
                                                select="'background-color:green;font-family:verdana;color:white'"
                                            />
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>

                                <xsl:value-of select="concat(Coverage, '%')"/>
                            </td>
                            <td style="font-family:verdana">
                                <xsl:value-of select="'***'"/>
                            </td>
                            <td style="text-align: center;font-family: verdana">
                                <xsl:if test="PassedScenarios/h5 = 0">
                                    <xsl:attribute name="style">
                                        <xsl:value-of
                                            select="'background-color:skyblue;font-family:verdana;text-align: center;'"
                                        />
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="PassedScenarios/h5"/>
                            </td>
                            <td style="text-align: center;font-family: verdana">
                                <xsl:if test="number(FailedScenarios/h5) > 0">
                                    <xsl:attribute name="style">
                                        <xsl:value-of
                                            select="'background-color:orchid;font-family:verdana;text-align: center;'"
                                        />
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="FailedScenarios/h5"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
                <h4 style="font-family:arial;font-weight: italic">
                    <xsl:value-of select="'XSLTs without XSPECs / XSLTs with failed XSPECs : '"/>
                </h4>
                <h4
                    style="font-family:arial;font-weight: italic;word-break: break-all;white-space: pre-line">
                    <xsl:value-of select="MissedMappings"/>
                </h4>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
