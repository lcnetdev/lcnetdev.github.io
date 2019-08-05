<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="http://www.loc.gov/standards/sru/bibframe/fullDisplay.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:srw="http://www.loc.gov/zing/srw/" xmlns:sru="http://docs.oasis-open.org/ns/search-ws/sruResponse" xmlns:dc="http://www.loc.gov/zing/srw/dcschema/v1.0/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:bf="http://bibframe.org/vocab/" version="1.0"
				exclude-result-prefixes="zr diag srw sru dc bf rdf">

	<xsl:output  encoding="UTF-8" indent="yes"/>

	<xsl:template match="text()"/>

	<xsl:template match="rdf:RDF">
		<xsl:variable name="base" select="bf:Work[1]/@rdf:about"/>
		<table>
			<xsl:for-each select="bf:*">
				<tr>
					<td>
						<b>
							<xsl:value-of select="name(.)"/>:</b>
						<xsl:variable name="n" select="@rdf:nodeID"/>
						<xsl:if test="$n">(<xsl:value-of select="$n"/>)</xsl:if>
						<xsl:if test="@rdf:about and @rdf:about != $base">
									<xsl:variable name="bnodedid">
										<xsl:value-of select="substring-after(@rdf:about, $base)"/>
									</xsl:variable>&#160;(<a name="{$bnodedid}"><xsl:value-of select="$bnodedid"/></a>)</xsl:if>
					</td>
				</tr>
				<xsl:for-each select="*">
					<xsl:variable name="lang" select="@xml:lang"/>
					<xsl:if test="not($lang='x-bf-hash')">
						<xsl:variable name="resource" select="@rdf:resource"/>
						<xsl:variable name="nodeid" select="@rdf:nodeID"/>			
						<tr>
							<td/>
							<td>
								<b>
									<xsl:value-of select="name(.)"/>:</b>								
							</td>
							<td/>
							<td>
								<xsl:choose>
									<xsl:when test="bf:Provider">
										<xsl:for-each select=".//bf:providerRole">
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
										<xsl:for-each select=".//bf:providerName">
											<b>Name:</b>
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
										<xsl:for-each select=".//bf:providerPlace">
											<b>Place:</b>
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
										<xsl:for-each select=".//bf:providerDate">
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
										<xsl:for-each select=".//bf:copyrightDate">
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
									</xsl:when>

									<xsl:when test="$resource">
										<xsl:variable name="rvalue" select="//*[@rdf:about=$resource]/*[1]/text()"/>
										<xsl:choose>
											<xsl:when test="$rvalue">
												<xsl:value-of select="$rvalue"/>&#160;(<a>
													<xsl:attribute name="href">
														<xsl:value-of select="concat('#',substring-after($resource, $base))"/>
													</xsl:attribute>
													<xsl:value-of select="substring-after($resource, $base)"/></a>)</xsl:when>
											<xsl:otherwise>
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$resource"/>
													</xsl:attribute>
													<xsl:value-of select="$resource"/>
												</a>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$nodeid">
										<xsl:variable name="rvalue" select="//*[@rdf:nodeID=$nodeid]/*[1]"/>
										<xsl:choose>
											<xsl:when test="$rvalue">
												<xsl:value-of select="$rvalue"/> (<xsl:value-of select="$nodeid"/>)</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$nodeid"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="bf:Identifier">
										<xsl:for-each select="bf:Identifier/*">
											<b>
												<xsl:value-of select="substring-after(name(.),'bf:identifier')"/>:</b>
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="/">
		<xsl:call-template name="html"/>
	</xsl:template>

	<xsl:template name="html">
		<html xmlns="http://www.w3.org/1999/xhtml">
		
			<head>

				<title>BIBFRAME Full Display</title>
				<link href="css.css" rel="stylesheet" type="text/css" media="screen, all"/>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			</head>
			<body>
				<div class="body">
					<xsl:apply-templates/>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="srw:searchRetrieveResponse">
		<h2>Search Results</h2>
		<xsl:call-template name="diagnostic"/>
		<xsl:call-template name="displaysearch"/>
	</xsl:template>

	<xsl:template name="diagnostic">
		<xsl:for-each select="//diag:diagnostic">
			<div class="diagnostic">
				<!-- <xsl:value-of select="diag:uri"/> -->
				<xsl:text> </xsl:text>
				<xsl:value-of select="diag:message"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="diag:details"/>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="displaysearch">
		<div class="searchresults">
			<xsl:for-each select="srw:numberOfRecords">
				<h4>
					<xsl:text>Number of Records: </xsl:text>
					<xsl:value-of select="."/>
				</h4>
			</xsl:for-each>
			<xsl:for-each select="srw:records">
				<xsl:for-each select="srw:record">
					<div class="record">
						<h4>
							<xsl:text>Record </xsl:text>
							<xsl:value-of select="srw:recordPosition"/>
						</h4>
						<p>
							<xsl:if test="srw:recordPacking='string'">
								<pre>
									<xsl:value-of select="srw:recordData"/>
								</pre>
							</xsl:if>
							<xsl:if test="srw:recordPacking='xml'">
								<xsl:choose>
									<xsl:when test="srw:recordSchema='marcxml'">
										<xsl:text>MARCXML</xsl:text>
									</xsl:when>
									<xsl:when test="srw:recordSchema='bibframe'">
										<xsl:apply-templates select="srw:recordData"/>
									</xsl:when>
								</xsl:choose>
							</xsl:if>

							<form name="rawlink" method="get">
								<input type="hidden" name="version">
									<xsl:attribute name="value">
										<xsl:value-of select="//srw:echoedSearchRetrieveRequest/srw:version"/>
									</xsl:attribute>
								</input>
								<input type="hidden" name="operation" value="searchRetrieve"/>
								<input type="hidden" name="query">
									<xsl:attribute name="value">
										<xsl:value-of select="//srw:echoedSearchRetrieveRequest/srw:query"/>
									</xsl:attribute>
								</input>
								<input type="hidden" name="recordPacking">
									<xsl:attribute name="value">
										<xsl:value-of select="srw:recordPacking"/>
									</xsl:attribute>
								</input>
								<input type="hidden" name="recordSchema">
									<xsl:attribute name="value">
										<xsl:value-of select="srw:recordSchema"/>
									</xsl:attribute>
								</input>
								<input type="hidden" name="startRecord">
									<xsl:attribute name="value">
										<xsl:value-of select="srw:recordPosition"/>
									</xsl:attribute>
								</input>
								<input type="hidden" name="maximumRecords" value="1"/>
								<input type="submit">
									<xsl:attribute name="value">
										<xsl:text>Raw Record </xsl:text>
										<xsl:value-of select="srw:recordPosition"/>
									</xsl:attribute>
								</input>
							</form>
						</p>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="http://lcweb2.loc.gov:8081/diglib/tools/bf/bibid/5226.rdf" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/><scenario default="yes" name="Scenario2" userelativepaths="yes" externalpreview="no" url="http://id.loc.gov/ml38287/marc2bibframe/xbin/ml.xqy?marcxmluri=http://id.loc.gov/resources/bibs/16000001.marcxml.xml&amp;serialization=rdf&amp;baseuri=http://id.loc.gov/resources/bibs/&amp;usebnodes=false" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext></MapperMetaTag>
</metaInformation>
-->