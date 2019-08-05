<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://lcnetdev.github.io/MARC21/slim" xmlns:fm="http://lcnetdev.github.io/MARC21/frbr/match" xmlns="http://lcnetdev.github.io/MARC21/frbr" xmlns:mods="http://lcnetdev.github.io/mods/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:include href="http://lcnetdev.github.io/marcxml/xslt/MARC21slimUtils.xsl"/>
	<xsl:output media-type="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:apply-templates select="marc:collection"/>
	</xsl:template>

	<xsl:template match="marc:collection">
		<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="http://lcnetdev.github.io/standards/marcxml/frbr/frbr2html.xsl"</xsl:processing-instruction>

		<frbr>
			<!-- match and display: 240 243 245 a n p -->
<!--			<xsl:for-each-group select="marc:record[fm:work/fm:author]" group-by="normalize-space(translate(concat(fm:work/fm:author,' ',fm:work/fm:title),'abcdefghijklmnopqrstuvwxyz,.;/-:[]()&quot;','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))">-->
			<xsl:for-each-group select="marc:record[fm:work/fm:author]" group-by="fm:work">
				<xsl:sort select="fm:work/fm:author"/>
				<xsl:sort select="normalize-space(translate(substring(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='a'][1],marc:datafield[@tag=130]/@ind1 | marc:datafield[@tag=240 or @tag=243 or @tag=245][1]/@ind2),'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
				<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='m'][1],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][1],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][2],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='r'][1],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='f'][1],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<work>
					<mods:name type="personal">
						<mods:namePart>
							<xsl:variable name="name">
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString">
										<xsl:for-each select="marc:datafield[@tag=100 or @tag=110 or @tag=111]">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">abcdnq</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:call-template name="dropFromOldCatalog">
								<xsl:with-param name="str" select="$name"/>
							</xsl:call-template>
						</mods:namePart>
						<mods:role>
							<mods:text>creator</mods:text>
						</mods:role>
					</mods:name>
					<xsl:for-each-group select="current-group()" group-by="fm:work/fm:title">
						<xsl:sort select="normalize-space(translate(fm:work/fm:title,'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
						<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='m'][1],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
						<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][1],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
						<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][2],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
						<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='r'][1],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
						<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='f'][1],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
						<xsl:call-template name="restOfWork"/>
					</xsl:for-each-group>
				</work>
			</xsl:for-each-group>
			<xsl:for-each-group select="marc:record[not(fm:work/fm:author)]" group-by="fm:work/fm:title">
				<xsl:sort select="fm:work/fm:title"/>
				<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='m'],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][1],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='n'][2],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<xsl:sort select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='r'],'abcdefghijklmnopqrstuvwxyz,.;/-:[]()','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
				<xsl:sort data-type="number" select="translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='f'],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;/-:[]()','')"/>
				<work>
					<xsl:call-template name="restOfWork"/>
				</work>
			</xsl:for-each-group>
		</frbr>
	</xsl:template>

	<xsl:template name="restOfWork">
		<mods:titleInfo>
			<mods:title>
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString">
						<xsl:variable name="str" select="normalize-space(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='a'])"/>

						<xsl:choose>
							<xsl:when test="contains($str,' [')">
								<xsl:value-of select="substring-before($str,' [')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$str"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245][1]/marc:subfield[@code='d' or @code='f' or @code='g' or @code='k' or @code='m' or @code='n' or @code='p' or @code='r' or @code='s']">
							<xsl:text> </xsl:text>
							<xsl:value-of select="."/>
						</xsl:for-each>
					</xsl:with-param>
				</xsl:call-template>
			</mods:title>
		</mods:titleInfo>
		<xsl:for-each-group select="current-group()" group-by="concat(fm:expression/fm:leader6,fm:expression/fm:controlField008-35-37)">
			<xsl:sort select="concat(fm:expression/fm:leader6,fm:expression/fm:controlField008-35-37)"/>
			<expression>
				<xsl:variable name="leader6" select="fm:expression/fm:leader6"/>
				<mods:typeOfResource>
					<xsl:choose>
						<xsl:when test="$leader6='a' or $leader6='t'">text</xsl:when>
						<xsl:when test="$leader6='e' or $leader6='f'">cartographic</xsl:when>
						<xsl:when test="$leader6='c' or $leader6='d'">notated music</xsl:when>
						<xsl:when test="$leader6='i' or $leader6='j'">sound recording</xsl:when>
						<xsl:when test="$leader6='k'">still image</xsl:when>
						<xsl:when test="$leader6='g'">moving image</xsl:when>
						<xsl:when test="$leader6='r'">three dimensional object</xsl:when>
						<xsl:when test="$leader6='m'">software, multimedia</xsl:when>
						<xsl:when test="$leader6='p'">mixed material</xsl:when>
						<xsl:otherwise>LDR6=<xsl:value-of select="$leader6"/></xsl:otherwise>
					</xsl:choose>
				</mods:typeOfResource>


				<xsl:variable name="controlField008-35-37" select="fm:expression/fm:controlField008-35-37"/>
				<xsl:if test="$controlField008-35-37">
					<mods:language authority="iso639-2b">
						<xsl:value-of select="$controlField008-35-37"/>
					</mods:language>
				</xsl:if>
				<manifestation>
					<xsl:for-each select="current-group()">
						<xsl:sort order="descending" select="substring(marc:controlfield[@tag=008],8,4)"/>
						<imprint>
							<xsl:for-each select="marc:datafield[@tag=245]">
								<mods:titleInfo>
									<mods:title>
										<xsl:call-template name="chopPunctuation">
											<xsl:with-param name="chopString">
												<xsl:call-template name="subfieldSelect">
													<xsl:with-param name="codes">anp</xsl:with-param>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</mods:title>
									<xsl:for-each select="marc:subfield[@code='b'][not(substring(.,1,1)='[')]">
										<mods:subTitle>
											<xsl:call-template name="chopPunctuation">
												<xsl:with-param name="chopString">
													<xsl:value-of select="."/>
												</xsl:with-param>
											</xsl:call-template>
										</mods:subTitle>
									</xsl:for-each>
								</mods:titleInfo>
							</xsl:for-each>

							<xsl:for-each select="marc:datafield[@tag=245]/marc:subfield[@code='c']">
								<mods:note type="statement of responsiblity">
									<xsl:value-of select="."/>
								</mods:note>
							</xsl:for-each>

							<mods:originInfo>
								<xsl:for-each select="marc:datafield[@tag=250]">
									<mods:edition>
										<xsl:variable name="datafield250ab">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">ab</xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="contains($datafield250ab,'[') and not(contains($datafield250ab,']'))">
												<xsl:value-of select="$datafield250ab"/>]</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$datafield250ab"/>
											</xsl:otherwise>
										</xsl:choose>
									</mods:edition>
								</xsl:for-each>
								<xsl:for-each select="marc:datafield[@tag=260]/marc:subfield[@code='b' or @code='c' or @code='g']">
									<xsl:choose>
										<xsl:when test="@code='b'">
											<mods:publisher>
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:choose>
															<xsl:when test="contains(.,']') and not(contains(.,'['))">
																<xsl:value-of select="substring-before(.,']')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="."/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>
											</mods:publisher>
										</xsl:when>
										<xsl:when test="@code='c'">
											<mods:dateIssued>
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:choose>
															<xsl:when test="contains(.,']') and not(contains(concat(.,../marc:subfield[@code='b'][1]),'['))">
																<xsl:value-of select="substring-before(.,']')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="."/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>
											</mods:dateIssued>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</mods:originInfo>

							<xsl:for-each select="marc:datafield[@tag=300]">
								<mods:physicalDescription>
									<mods:extent>
										<xsl:call-template name="subfieldSelect">
											<xsl:with-param name="codes">abefg3c</xsl:with-param>
										</xsl:call-template>
									</mods:extent>
								</mods:physicalDescription>
							</xsl:for-each>

							<xsl:for-each select="marc:datafield[@tag=020]">
								<mods:identifier type="ISBN">
									<xsl:call-template name="chopPunctuation">
										<xsl:with-param name="chopString">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">acz</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</mods:identifier>
							</xsl:for-each>
							<xsl:for-each select="marc:datafield[@tag=022]">
								<mods:identifier type="ISSN">
									<xsl:call-template name="chopPunctuation">
										<xsl:with-param name="chopString">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">ayz</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</mods:identifier>
							</xsl:for-each>
							<xsl:for-each select="marc:datafield[@tag=028]">
								<mods:identifier type="Publisher Number">
									<xsl:call-template name="chopPunctuation">
										<xsl:with-param name="chopString">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">ab</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</mods:identifier>
							</xsl:for-each>
							<xsl:for-each select="marc:datafield[@tag=030]">
								<mods:identifier type="CODEN">
									<xsl:call-template name="chopPunctuation">
										<xsl:with-param name="chopString">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">az</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</mods:identifier>
							</xsl:for-each>
							<xsl:for-each select="marc:datafield[@tag=533]">
								<mods:identifier type="Reproduction">
									<xsl:call-template name="subfieldSelect">
										<xsl:with-param name="codes">abcdefmn3</xsl:with-param>
									</xsl:call-template>
								</mods:identifier>
							</xsl:for-each>
							<xsl:for-each select="marc:datafield[@tag=010]">
								<mods:identifier type="lccn">
									<xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
								</mods:identifier>
							</xsl:for-each>
						</imprint>
					</xsl:for-each>
				</manifestation>
			</expression>
		</xsl:for-each-group>
	</xsl:template>

	<!--	<xsl:template match="marc:subfield[@code='n']">
		<mods:partNumber><xsl:call-template name="chopIfLast"/></mods:partNumber>
	</xsl:template>
	<xsl:template match="marc:subfield[@code='p']">
		<mods:partName><xsl:call-template name="chopIfLast"/></mods:partName>
	</xsl:template>
-->
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
<scenarios ><scenario default="yes" name="Scenario2" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\..\..\..\..\frbr\match.xml" htmlbaseurl="" outputurl="" processortype="custom" commandline="java  &#x2D;jar C:\saxon7&#x2D;8\saxon7.jar &#x2D;o %3 %1 %2" additionalpath="c:\j2sdk1.4.1\bin" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->