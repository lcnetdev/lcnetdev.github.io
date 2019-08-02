<?xml version="1.0" encoding="utf-8"?>
<!--* 
<!DOCTYPE xsl:stylesheet PUBLIC 'http://www.w3.org/1999/XSL/Transform'
      '/SGML/Public/W3C/xslt10.dtd' >
*-->
<!-- sw2rss.xsl, style sheet to generate an RSS feed of the w3c semantic web home page, $Id: html2rss.xsl,v 1.20 2003/04/29 02:22:53 cmsmcq Exp $  -->

<xsl:stylesheet
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns="http://purl.org/rss/1.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
  version="1.0">

<xsl:param name =" Base" />
<xsl:param name =" Channel" />
<xsl:param name =" xmlfile" />
<xsl:param name =" xslfile" />
<xsl:param name =" Page" />

<xsl:output method="xml" indent="yes" encoding="us-ascii"/>

<xsl:template match="/h:html">
  <xsl:processing-instruction name="xml-stylesheet">href="http://www.w3.org/2000/08/w3c-synd/style.css" type="text/css"</xsl:processing-instruction>

  <rdf:RDF>
    <channel rdf:about="{$Channel}">
      <title><xsl:value-of select="./h:head/h:title"/></title>
      <link><xsl:value-of select="$Page" /></link>
      <description><xsl:value-of select='normalize-space(./h:body//h:span[@class="summary"])'/></description>

      <!-- table of contents: for each news item get the first <a> -->

      <items>
        <rdf:Seq>

          <xsl:for-each select='./h:body//h:div[@class="item"]'>
            <!--* 
            <xsl:variable name="ref" select='.//h:a[@class="link"]/@href' /> 
            *-->
            <xsl:variable name="ref">
              <xsl:call-template name="absolutizeURI">
                <xsl:with-param name="base" select="$Base"/>
                <xsl:with-param name="u" 
                                select='.//h:a[@class="link"]/@href' /> 
              </xsl:call-template>
            </xsl:variable>
	    <rdf:li rdf:resource="{$ref}" />

          </xsl:for-each>
	</rdf:Seq>
      </items>
    </channel>

    <xsl:for-each select='./h:body//h:div[@class="item"]'>
      <!--*
      <xsl:variable name="ref" select='.//h:a[@class="link"]/@href' />
      *-->
      <xsl:variable name="ref">
        <xsl:call-template name="absolutizeURI">

          <xsl:with-param name="base" select="$Base"/>
          <xsl:with-param name="u" 
                          select='.//h:a[@class="link"]/@href' /> 
        </xsl:call-template>
      </xsl:variable>
	    
      <item rdf:about="{$ref}">
        <title><xsl:value-of select='normalize-space(.//h:span[@class="title"])'/></title>
	<link><xsl:value-of select="$ref"/></link>
        <dc:date><xsl:value-of select='normalize-space(.//h:span[@class="date"])'/></dc:date>
        <description><xsl:value-of select='.//h:span[@class="description"]/.'/></description>

      </item>
    </xsl:for-each>
  </rdf:RDF>
</xsl:template>

 <!--* absolutizeURI: named template to resolve a relative URI
     * with reference to a base URI
     * MSM, 2003-04-28
     *-->
 <xsl:template name="absolutizeURI">
  <!--* take two parameters: a url (u) and a base url (base).  
      * u is a URI which may or may not be relative. 
      *-->
  <xsl:param name="base"></xsl:param>
  <xsl:param name="u"></xsl:param>

  <!--* If u is absolute, return.
      * If u begins //, parse base and glue things together
      * If u begins /, parse base and glue things together
      * Otherwise, call resolve-relative and return its result
      *-->
  <xsl:choose>
   <xsl:when test="starts-with($u,'http:')
    or starts-with($u,'ftp:')
    or starts-with($u,'gopher:')
    or starts-with($u,'mailto:')
    or starts-with($u,'news:')
    or starts-with($u,'telnet:')">
    <!--* u is absolute and uses a well known scheme: return u *-->
    <xsl:value-of select="$u"/>
   </xsl:when>
   <xsl:when test="contains($u,':') 
    and normalize-space(
          translate(
            substring-before($u,':'),
            'abcdefghijklmnopqrstuvwxyz0123456789+.-',
            ' '))
        = ''">
    <!--* $u begins with a scheme name (letters followed by :),
        * though not a very common one. Return u *-->
    <xsl:value-of select="$u"/>

   </xsl:when>
   <xsl:when test="starts-with($u,'//')">
    <!--* u is a net_path, ie u starts with double slash and host.
        * supply scheme from base, glue together, return *-->
    <xsl:value-of select="concat(
     substring-before($base,':'),
     ':',
     $u)"/>
   </xsl:when>
   <xsl:when test="starts-with($u,'/')">
    <!--* u is an abs_path, ie u starts with single slash.
        * supply scheme and host from base, glue together, return *-->
    <!--* n.b. we are assuming a URI structure with a host and 
        * path part here, safe if the base is an HTTP URI and
        * possibly false otherwise. We'll risk it. 
        *-->
    <xsl:value-of select="concat(
     substring-before($base,'://'),
     '://',
     substring-before(substring-after($base,'://'),'/'),
     $u)"/>

   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="resolve-relative-URI">
     <xsl:with-param name="base" select="$base"/>
     <xsl:with-param name="u" select="$u"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--* resolve-relative-URI: given a relative-path URI reference,
     * merge it with the base URI's path.
     * We follow slavishly the algorithm in RFC 2396;
     * most of the work is done by initializing variables, 
     * in sequence.
     * N.B. this didn't have to be a separate template,
     * I just made it separate to make it look simpler. -MSM
     *-->
 <xsl:template name="resolve-relative-URI">
  <xsl:param name="base"></xsl:param>
  <xsl:param name="u"></xsl:param>
  
  <!--* (a) isolate base scheme, base authority, and base path,
      *     and strip off everything after the last slash
      *     in the path *-->
  <xsl:variable name="base-scheme" 
   select="substring-before($base,':')" />
  <xsl:variable name="base-authority" 
   select="substring-before(substring-after($base,'://'),'/')" />
  <xsl:variable name="base-path-temp"
   select="substring-after(substring-after($base,'://'),'/')"/>

  <xsl:variable name="base-path">
   <xsl:call-template name="strip-last-segment">
    <xsl:with-param name="s">
     <xsl:choose>
      <!--* if the base has a ? or #, strip it off now, lest
          * there be a slash after the ? or # which would mess 
          * us up *-->
      <xsl:when test="contains($base-path-temp,'?')">
       <xsl:value-of select="substring-before($base-path-temp,'?')"/>
      </xsl:when>
      <xsl:when test="contains($base-path-temp,'#')">

       <xsl:value-of select="substring-before($base-path-temp,'#')"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$base-path-temp"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>

  <!--* assert: base-scheme, base-authority, base-path are initialized *-->

  <!--* (b) concatenate (restoring the leading / of base-path) *-->
  <!--* (c) remove path segments of the form ./ *-->
  <xsl:variable name="step-c">
   <xsl:call-template name="remove-single-dots">
    <xsl:with-param name="s" select="concat('/',$base-path,$u)"/>
   </xsl:call-template>
  </xsl:variable>

  <!--* (d) strip trailing path segment of '.' *-->
  <xsl:variable name="step-d">
   <xsl:choose>
    <xsl:when test="substring($step-c,string-length($step-c) - 1) = '/.'">
     <!--* if path ends /. then remove the . *-->
     <xsl:value-of 
      select="substring($step-c,1,string-length($step-c) - 1)"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$step-c"/></xsl:otherwise>

   </xsl:choose>
  </xsl:variable>

  <!--* (e) remove <segment>/../ *-->
  <xsl:variable name="step-e">
   <xsl:call-template name="remove-double-dots">
    <xsl:with-param name="s" select="$step-d"/>
   </xsl:call-template>
  </xsl:variable>

  <!--* (f) strip trailing <segment>/.. *-->
  <xsl:variable name="step-f">
   <xsl:choose>
    <xsl:when test="substring($step-e,string-length($step-e) - 2) 
     = '/..'">
     <!--* if path ends /foo/.. then remove the /.. and the
         * preceding segment *-->
     <xsl:call-template name="strip-last-segment">
      <xsl:with-param name="s"
       select="substring($step-c,1,string-length($step-e) - 3)"/>
     </xsl:call-template>

    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$step-e"/></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <!--* (g) check for ../ at front of path *-->
  <xsl:if test="starts-with($step-f,'/..')">
   <xsl:message>Ouch! more .. than I know what to do with:</xsl:message>
   <xsl:message><xsl:value-of select="$step-f"/></xsl:message>

  </xsl:if>

  <!--* (h) return *-->
  <xsl:value-of select="concat($base-scheme,'://',$base-authority,$step-f)"/>
 </xsl:template>

 <!--* utilities *-->
 <!--* strip-last-segment: remove everything following the last '/' in s *-->
 <xsl:template name="strip-last-segment">
  <xsl:param name="s"></xsl:param>

  <xsl:choose>
   <xsl:when test="contains($s,'/')">
    <xsl:variable name="lhs" select="substring-before($s,'/')"/>
    <xsl:variable name="rhs">
     <xsl:call-template name="strip-last-segment">
      <xsl:with-param name="s" select="substring-after($s,'/')"/>
     </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($lhs,'/',$rhs)"/>

   </xsl:when>
   <xsl:otherwise>
    <!--* s contains no slash.  We are done *-->
    <xsl:value-of select="''"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <!--* remove-single-dots: replace '/./' with '/' until all done *-->
 <xsl:template name="remove-single-dots">

  <xsl:param name="s"></xsl:param>
  <xsl:choose>
   <xsl:when test="contains($s,'/./')">
    <xsl:call-template name="remove-single-dots">
     <xsl:with-param name="s" select="concat(
      substring-before($s,'/./'),
      '/',
      substring-after($s,'/./')
      )"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
  </xsl:choose>

 </xsl:template>

 <!--* remove-double-dots: 
     * replace '/segment/../' with '/' until all done *-->
 <xsl:template name="remove-double-dots">
  <xsl:param name="s"></xsl:param>
  <!--* assert: $s will begin with '/' *-->
  <xsl:if test="not(starts-with($s,'/'))">
   <xsl:message>Ouch! I thought this string would start with a slash!</xsl:message>
   <xsl:message><xsl:value-of select="$s"/></xsl:message>

  </xsl:if>
  <xsl:choose>
   <xsl:when test="contains(substring($s,2),'/../')">
    <!--* strip the segment before the /../ *-->
    <xsl:variable name="lhs">
     <xsl:call-template name="strip-last-segment">
      <xsl:with-param name="s"
       select="substring-before(substring($s,2),'/../')"/>
     </xsl:call-template>
    </xsl:variable>

    <!--* collect the path after the /../ *-->
    <xsl:variable name="rhs"
     select="substring-after(substring($s,2),'/../')"/>
    <!--* recur; remember $lhs ends with slash *-->
    <xsl:call-template name="remove-double-dots">
     <xsl:with-param name="s" select="concat('/',$lhs,$rhs)"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
  </xsl:choose>

 </xsl:template>
</xsl:stylesheet>
<!-- Keep this comment at the end of the file
Local variables:
mode: xml
sgml-default-dtd-file:(concat sgmlvol "/SGML/Public/Emacs/xslt.ced")
sgml-omittag:t
sgml-shorttag:t
sgml-indent-data:t
sgml-indent-step:1
End:
-->