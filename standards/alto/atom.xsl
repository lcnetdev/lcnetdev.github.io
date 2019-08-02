<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:at="http://purl.org/atompub/tombstones/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xhtml atom at">
    <xsl:param name="output" required="yes"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/atom:feed">
        <xsl:if test="$output eq 'main'">
            <div id="news-wrapper">
                <xsl:apply-templates select="atom:entry" mode="mainhtml"/>
            </div>
        </xsl:if>
        <xsl:if test="$output eq 'sidebar'">
            <div id="skip_menu" class="box">
                <h2 class="homepage">
                    <xsl:text>News </xsl:text>
                    <span class="extra">
                        <a href="/standards/alto/feed.atom">
                            <img src="/standards/alto/images/subscribe.gif" alt="Subscribe to ALTO news feed"/>
                        </a>
                    </span>
                </h2>
                <xsl:apply-templates select="atom:entry[position() lt 5]" mode="sidebar"/>
                <h2 class="homepage">Schema</h2>
                <ul>
                    <li><a href="/standards/alto/alto-v2.0.xsd">Current version (v.2.0 alpha)</a></li>
                </ul>
                <!--<h2 class="homepage">ALTO Editorial Board</h2>
                <ul>
                <li>Wiki area</li>
                </ul>-->
                <h2 class="homepage">Listserv</h2>
                <ul>
                    <li><a href="http://listserv.loc.gov/cgi-bin/wa?SUBED1=alto&amp;A=1">Subscribe</a>, <a href="http://listserv.loc.gov/archives/alto.html">archives</a></li>
                </ul>
                <br/>
                <hr class="dashed" />
                <div class="pdfSmall">
                    <p>Documents using the PDF format can be read using free software like <a href="http://www.adobe.com/products/reader/">Adobe Acrobat Reader</a>. <img src="/standards/alto/images/newsite.gif" alt="External link: http://www.adobe.com/products/reader/"/></p>
                    <p class="pdfCenter">
                        <img src="/standards/alto/images/get_adobe_reader.gif" alt="Get Acrobat Reader"/>
                    </p>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="atom:entry" mode="mainhtml">
        <xsl:variable name="frag" select="substring-after(atom:id, '#')"/>
        <div class="atom-entry" id="{$frag}">
            <h4 class="atom-headline">
                <xsl:apply-templates select="atom:title"/>
            </h4>
            <span style="font-size: smaller;">
                <b>
                    <xsl:value-of select="replace(atom:published, '(\d{4}-\d{2}-\d{2}).+$', '$1', 'mi')"/>
                </b>
            </span>
            <p>
                <em>
                    <xsl:apply-templates select="atom:summary"/>
                </em>
            </p>
            <xsl:copy-of exclude-result-prefixes="#all" copy-namespaces="no" select="atom:content/xhtml:div"/>
            <span class="backToTop"><a href="#mainbody">↑ Back to top ↑</a></span>
        </div>
    </xsl:template>
    <xsl:template match="atom:entry" mode="sidebar">
        <xsl:variable name="frag" select="substring-after(atom:id, '#')"/>
        <ul>
            <li>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('/standards/alto/news.php#', $frag)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="atom:title"/>
                </a>
                <br/>
                <span style="font-size: smaller;">
                    <b>
                        <xsl:value-of select="replace(atom:published, '(\d{4}-\d{2}-\d{2}).+$', '$1', 'mi')"/>
                    </b>
                </span>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="feed.atom" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="" ><parameterValue name="output" value="'sidebar'"/></scenario></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext></MapperMetaTag>
</metaInformation>
-->