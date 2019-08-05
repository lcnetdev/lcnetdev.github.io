<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://lcnetdev.github.io/MARC21/slim" xmlns:fm="http://lcnetdev.github.io/MARC21/frbr/match" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="http://lcnetdev.github.io/standards/marcxml/xslt/MARC21slimUtils.xsl"/>
	<xsl:output media-type="xml" indent="yes"/>

	<xsl:template match="node()|@*">
		<!-- Copy the current node -->
		<xsl:copy>
			<!-- Including any attributes it has and any child nodes -->
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="marc:record">
		<xsl:copy>
			<fm:work>
				<xsl:choose>
					<xsl:when test="marc:datafield[@tag=100]">
						<fm:author>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">100</xsl:with-param>
								<xsl:with-param name="codes">abcd</xsl:with-param>
							</xsl:call-template>
						</fm:author>
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=110]">
						<fm:author>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">110</xsl:with-param>
								<xsl:with-param name="codes">abcd</xsl:with-param>
							</xsl:call-template>
						</fm:author>
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=111]">
						<fm:author>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">111</xsl:with-param>
								<xsl:with-param name="codes">abcdnq</xsl:with-param>
							</xsl:call-template>
						</fm:author>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="marc:datafield[@tag=130]">
						<fm:title>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">130</xsl:with-param>
								<xsl:with-param name="codes">adgknmpr</xsl:with-param>
								<xsl:with-param name="nonFileInd" select="1"/>
							</xsl:call-template>
						</fm:title>
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=240]">
						<fm:title>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">240</xsl:with-param>
								<xsl:with-param name="codes">adgknmpr</xsl:with-param>
								<xsl:with-param name="nonFileInd" select="2"/>
							</xsl:call-template>
						</fm:title>
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=243]">
						<fm:title>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">243</xsl:with-param>
								<xsl:with-param name="codes">adgknmpr</xsl:with-param>
								<xsl:with-param name="nonFileInd" select="2"/>
							</xsl:call-template>
						</fm:title>
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=245]">
						<fm:title>
							<xsl:call-template name="matchField">
								<xsl:with-param name="tag">245</xsl:with-param>
								<xsl:with-param name="codes">adgknmpr</xsl:with-param>
								<xsl:with-param name="nonFileInd" select="2"/>
							</xsl:call-template>
						</fm:title>
					</xsl:when>
				</xsl:choose>
				<!--	substring(concat(    
			marc:datafield[@tag=130]/@ind1 | marc:datafield[@tag=240 or @tag=243 or @tag=245]/@ind2)),    
			'abcdefghijklmnopqrstuvwxyz,.;/-:[]()&quot;','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>-->
			</fm:work>
			<fm:expression>
				<xsl:variable name="controlField008" select="marc:controlfield[@tag=008]"/>
				<xsl:variable name="controlField008-35-37" select="normalize-space(translate(substring($controlField008,36,3),'|#',''))"/>
				<xsl:variable name="leader" select="marc:leader"/>
				<xsl:variable name="leader6" select="substring($leader,7,1)"/>
				<fm:leader6>
					<xsl:value-of select="$leader6"/>
				</fm:leader6>
					<xsl:if test="$controlField008-35-37 and $controlField008-35-37 != 'n/a'">
						<fm:controlField008-35-37>
							<xsl:value-of select="$controlField008-35-37"/>
						</fm:controlField008-35-37>
					</xsl:if>
			</fm:expression>

			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="matchField">
		<xsl:param name="tag"/>
		<xsl:param name="codes"/>
		<xsl:param name="nonFileInd"/>
		<xsl:attribute name="fromTag">
			<xsl:value-of select="$tag"/>
		</xsl:attribute>
		<xsl:attribute name="fromCodes">
			<xsl:value-of select="$codes"/>
		</xsl:attribute>
		<xsl:for-each select="marc:datafield[@tag=$tag][1]">
			<xsl:variable name="nonFile">
				<xsl:choose>
					<xsl:when test="$nonFileInd=1">
						<xsl:value-of select="@ind1+1"/>
					</xsl:when>
					<xsl:when test="$nonFileInd=2">
						<xsl:value-of select="@ind2+1"/>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="subfields">
				<xsl:call-template name="subfieldSelect">
					<xsl:with-param name="codes" select="$codes"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="chopToAlpha">
				<xsl:with-param name="str" select="normalize-space(translate(substring($subfields,$nonFile),'abcdefghijklmnopqrstuvwxyz,.;/-:[]()&quot;','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="chopToAlpha">
		<xsl:param name="str"/>
		<xsl:variable name="lastChar" select="substring($str,string-length($str),1)"/>
		<xsl:choose>
			<xsl:when test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',$lastChar)">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="chopToAlpha">
					<xsl:with-param name="str" select="substring($str,1,string-length($str)-1)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="chopIfLast">
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="dropFromOldCatalog">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str,'[from old catalog]')">
				<xsl:value-of select="substring-before($str,'[from old catalog]')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\..\..\..\..\frbr\clean.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->