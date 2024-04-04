<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns1="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="ScenarioCoverageResult"/>
    <xsl:param name="ScenarioCoverageReport"/>
    <xsl:param name="DateRun"/>
    <xsl:template match="ns1:html" xmlns:ns1="http://www.w3.org/1999/xhtml">
        <html>
            <head>
                <style>
                    table,
                    th,
                    td {
                    border: 1px solid black;
                    }</style>
            </head>
            <body>
                <h2 style="font-family:arial;font-weight: bold">Code Coverage Report</h2>
                <h3 style="font-family:arial;font-weight: bold">
                	<xsl:value-of select="concat('Date of Coverage Report Run : ',$DateRun)"/>
                </h3>
                <table>
                    <tr style="font-weight: bold;background-color:skyblue">
                        <th style="font-family:arial;text-align:left">Map Name</th>
                        <th style="font-family:arial;text-align:left">Code</th>
                        <th style="font-family:arial;text-align:left">Number of Lines</th>
                    </tr>

                    <xsl:for-each select="ns1:body/ns1:pre">
                        <xsl:variable name="pos">
                            <xsl:value-of select="position()"/>
                        </xsl:variable>
                        <xsl:variable name="XSLfile">
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:value-of select="../ns1:h2[$pos]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="../ns1:h2[2]"/>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:variable>
                        <xsl:variable name="XSLTName">
                            <xsl:call-template name="substring-after-last">
                                <xsl:with-param name="input"
                                    select="substring-before($XSLfile, '.xsl')"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <tr>
                            <td>
                                <xsl:value-of select="''"/>
                            </td>
                            <td style="font-family:arial;font-weight: bold;background-color:lime">
                                <xsl:choose>
                                    <xsl:when test="contains($XSLTName, 'MAPPING_ANY_')">
                                        <xsl:value-of select="'TotalLines***'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'TotalLines'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="font-family:arial;text-align:center;background-color:lime;font-weight: bold;">
                                <xsl:value-of
                                    select="count(ns1:span[@class = 'hit']) + count(ns1:span[@class = 'missed'])"
                                />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <xsl:value-of select="''"/>
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="contains($XSLTName, 'MAPPING_ANY_')">
                                        <xsl:value-of select="'ExecutedLines***'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'ExecutedLines'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="font-family:arial;text-align:center;">
                                <xsl:value-of select="count(ns1:span[@class = 'hit'])"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <xsl:value-of select="''"/>
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="contains($XSLTName, 'MAPPING_ANY_')">
                                        <xsl:value-of select="'MissedLines***'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'MissedLines'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="font-family:arial;text-align:center;">
                                <xsl:value-of select="count(ns1:span[@class = 'missed'])"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-family:arial;background-color:cyan">
                                <xsl:choose>
                                    <xsl:when test="contains($XSLTName, 'MAPPING_ANY_')">
                                        <b>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="$ScenarioCoverageReport"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$XSLTName"/>
                                                <!--<xsl:value-of
                                            select="'Click here for complete Coverage Report'"/>-->
                                            </a>
                                        </b>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$XSLTName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="font-family:arial;background-color:cyan;font-weight: bold;">
                                <xsl:value-of select="'Code Coverage'"/>
                            </td>
                            <td style="font-family:arial;background-color:cyan;text-align:center;font-weight: bold;">
                                <xsl:if
                                    test="(count(ns1:span[@class = 'hit']) + count(ns1:span[@class = 'missed'])) > 0">
                                    <xsl:value-of
                                        select="concat(format-number(count(ns1:span[@class = 'hit']) div (count(ns1:span[@class = 'hit']) + count(ns1:span[@class = 'missed'])) * 100, '00.00'), '%')"
                                    />
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
                <br/>
                <h2 style="font-weight: bold;font-family:arial;">Templates Iteration details</h2>
                <table>
                    <tr style="background-color:yellow">
                        <th style="font-weight: bold;font-family:arial;text-align:left">Template Name</th>
                        <th style="font-weight: bold;font-family:arial;text-align:left">Code</th>
                        <th style="font-weight: bold;font-family:arial;text-align:left">Number of Iterations</th>
                    </tr>
                    <xsl:variable name="format">
                        <xsl:for-each select="ns1:body/ns1:pre/ns1:span[@class = 'hit']">
                            <xsl:sort select="."/>
                            <xsl:if test="starts-with(., '&lt;xsl:call-template name=')">
                                <xsl:value-of
                                    select="concat(substring-before(substring-after(., 'name='), '&gt;'), ',')"
                                />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:call-template name="splitStringToItems">
                        <xsl:with-param name="list" select="$format"/>
                        <xsl:with-param name="delimiter" select="','"/>
                    </xsl:call-template>
                </table>
                <h2 style="font-weight: bold;font-family:arial;">
                    <xsl:value-of select="'Summary of Coverage Results'"/>
                </h2>
                <h5 style="font-weight: bold;font-family:arial;">
                    <xsl:value-of
                        select="normalize-space(concat('Total Scenarios Passed:', normalize-space(substring-after(document($ScenarioCoverageResult)/ns1:html/ns1:body/ns1:table/ns1:thead/ns1:tr/ns1:th[2], 'passed:&#160;'))))"
                    />
                </h5>
                <h5 style="font-weight: bold;font-family:arial;">
                    <xsl:value-of
                        select="normalize-space(concat('Total Scenarios Failed:', normalize-space(substring-after(document($ScenarioCoverageResult)/ns1:html/ns1:body/ns1:table/ns1:thead/ns1:tr/ns1:th[4], 'failed:&#160;'))))"
                    />
                </h5>
                <a style="font-family:arial;">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ScenarioCoverageResult"/>
                    </xsl:attribute>
                    <xsl:value-of select="'Click here for complete Coverage Result'"/>
                </a>

                <table>
                    <tr style="background-color:magenta">
                        <th style="font-family:arial;text-align:left">#</th>
                        <th style="font-family:arial;text-align:left">Scenario Name</th>
                        <th style="font-family:arial;text-align:left;background-color:mediumspringgreen">Passed</th>
                        <th style="font-family:arial;text-align:left;background-color:tomato">Failed</th>
                    </tr>

                    <xsl:for-each
                        select="document($ScenarioCoverageResult)/ns1:html/ns1:body/ns1:table/ns1:tbody/ns1:tr">
                        <tr>
                            <td style="text-align:left;font-family:arial;">
                                <xsl:value-of select="position()"/>
                            </td>
                            <td style="font-family:arial;">
                                <xsl:value-of select="ns1:th/ns1:a"/>
                            </td>
                            <td style="font-family:arial;text-align:center">
                                <xsl:choose>
                                    <xsl:when test="@class = 'successful'">
                                        <xsl:attribute name="style">font-family:arial;background-color:mediumspringgreen;text-align:center</xsl:attribute>
                                        <xsl:value-of select="ns1:th[5]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style">font-family:arial;background-color:white;text-align:center</xsl:attribute>
                                        <xsl:value-of select="'0'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td style="font-family:arial;text-align:center">
                                <xsl:choose>
                                    <xsl:when test="@class = 'failed'">
                                        <xsl:attribute name="style">font-family:arial;background-color:tomato;text-align:center</xsl:attribute>
                                        <xsl:value-of select="ns1:th[5]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style">font-family:arial;background-color:white;text-align:center</xsl:attribute>
                                        <xsl:value-of select="'0'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="splitStringToItems">
        <xsl:param name="list"/>
        <xsl:param name="delimiter" select="','"/>
        <xsl:param name="count" select="1"/>
        <xsl:variable name="_delimiter">
            <xsl:choose>
                <xsl:when test="string-length($delimiter) = 0">,</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$delimiter"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="newlist">
            <xsl:choose>
                <xsl:when test="contains($list, $_delimiter)">
                    <xsl:value-of select="normalize-space($list)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(normalize-space($list), $_delimiter)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="first" select="substring-before($newlist, $_delimiter)"/>
        <xsl:variable name="remaining" select="substring-after($newlist, $_delimiter)"/>

        <xsl:if test="not(contains($remaining, $first))">
            <tr>
                <td style="text-align:left;font-family:arial;">
                    <xsl:value-of select="$first"/>
                </td>
                <td style="text-align:left;font-family:arial;">
                    <xsl:value-of select="'Number of times template called'"/>
                </td>
                <td style="text-align:center;font-family:arial;">
                    <xsl:value-of select="$count"/>
                </td>
            </tr>
        </xsl:if>
        <xsl:variable name="vcount">
            <xsl:choose>
                <xsl:when test="not(contains($remaining, $first))">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number($count) + 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$remaining">
            <xsl:call-template name="splitStringToItems">
                <xsl:with-param name="list" select="$remaining"/>
                <xsl:with-param name="delimiter" select="$_delimiter"/>
                <xsl:with-param name="count" select="number($vcount)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="substring-after-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>

        <!-- Extract the string which comes after the first occurence -->
        <xsl:variable name="temp" select="substring-after($input, $substr)"/>

        <xsl:choose>
            <!-- If it still contains the search string the recursively process -->
            <xsl:when test="$substr and contains($temp, $substr)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$temp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
