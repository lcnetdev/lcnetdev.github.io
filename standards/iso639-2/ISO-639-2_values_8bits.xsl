<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">

<html>

<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>



<body bgcolor="#ffffff">
<pre>
		<xsl:apply-templates/>
		</pre>
		</body>

</html>
	</xsl:template>
	<xsl:template match="language">
		<xsl:value-of select="iso_639_2B"/>|<xsl:value-of select="iso_639_2T"/>|<xsl:value-of select="iso_639_1"/>|<xsl:value-of select="comb_English"/>|<xsl:value-of select="comb_French"/>|<xsl:value-of select="German"/>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="file:///n:/nate/iso639&#x2D;2.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext></MapperMetaTag>
</metaInformation>
-->