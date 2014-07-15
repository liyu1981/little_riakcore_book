<?xml version="1.0" encoding="ASCII"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim" xmlns:xverb="xalan://com.nwalsh.xalan.Verbatim" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:exsl="http://exslt.org/common" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="sverb xverb lxslt exsl" version="1.0">

<!-- ********************************************************************
     $Id: verbatim.xsl 9589 2012-09-02 20:52:15Z tom_schr $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     LI, Yu: overwrite docbook's highlighting part

     ******************************************************************** -->

<xsl:template match="//programlisting">
  <pre class="programlisting" data-language="{@language}">
    <xsl:apply-templates/>
  </pre>
</xsl:template>

<xsl:template match="//programlisting//co">[link[coid#<xsl:value-of select="@id"/>]]</xsl:template>

<xsl:template match="//programlisting//text()">
  <xsl:message>Matched text element <xsl:value-of select="." disable-output-escaping="yes" /></xsl:message>
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
