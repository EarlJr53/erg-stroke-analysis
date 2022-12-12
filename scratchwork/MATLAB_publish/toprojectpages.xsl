<?xml version="1.0" encoding="utf-8"?>

<!--
This is an XSL stylesheet which converts mscript XML files into HTML.
Use the XSLT command to perform the conversion.

Copyright 1984-2012 The MathWorks, Inc.

Copyright (c) 2013, Kaelin Colclasure
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution
    * Neither the name of the Ohmware nor the names
      of its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Modified Extensively for Project-Pages by Ahmet Cecen

-->

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> <!ENTITY reg "&#174;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mwsh="http://www.mathworks.com/namespace/mcode/v1/syntaxhighlight.dtd"
  exclude-result-prefixes="mwsh">
  <xsl:output method="html"
    indent="no"/>
  <xsl:strip-space elements="mwsh:code"/>

<xsl:variable name="title">
  <xsl:variable name="dTitle" select="//steptitle[@style='document']"/>
  <xsl:choose>
    <xsl:when test="$dTitle"><xsl:value-of select="$dTitle"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="mscript/m-file"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<xsl:template match="mscript">---
layout:     post
title:      New Matlab Script
date:       2016-05-02 
author:     Ahmet Cecen
tags: 		matlab workflows
subtitle:   Some Short Description of the Script
visualworkflow: true
---
{% if page.visualworkflow == true %}
   {% include workflowmatlab.html %}
{% endif %}   
   

<xsl:comment>
This HTML was auto-generated from MATLAB code.
To make changes, update the MATLAB code and republish this document.
</xsl:comment>
    
<xsl:call-template name="header"/>

<!-- Determine if the there should be an introduction section. -->
<xsl:variable name="hasIntro" select="count(cell[@style = 'overview'])"/>

<!-- If there is an introduction, display it. -->
<xsl:if test = "$hasIntro">
<xsl:comment>introduction</xsl:comment>
<xsl:apply-templates select="cell[1]/text"/>
<xsl:comment>/introduction</xsl:comment>
</xsl:if>

<xsl:variable name="body-cells" select="cell[not(@style = 'overview')]"/>

<!-- Include contents if there are titles for any subsections. -->
<xsl:if test="count(cell/steptitle[not(@style = 'document')])">
<xsl:call-template name="contents">
<xsl:with-param name="body-cells" select="$body-cells"/>
</xsl:call-template>
</xsl:if>

<!-- Loop over each cell -->
<xsl:for-each select="$body-cells">
<!-- Title of cell -->
<xsl:if test="steptitle">
<xsl:variable name="headinglevel">
<xsl:choose>
<xsl:when test="steptitle[@style = 'document']">h1</xsl:when>
<xsl:otherwise>h2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:element name="{$headinglevel}">
<xsl:apply-templates select="steptitle"/>
<xsl:if test="not(steptitle[@style = 'document'])">
<a>
<xsl:attribute name="name">
<xsl:value-of select="position()"/>
</xsl:attribute>
</a>
</xsl:if>
</xsl:element>
</xsl:if>

<!-- Contents of each cell -->
<xsl:apply-templates select="text"/>
<xsl:apply-templates select="mcode-xmlized"/>
<xsl:apply-templates select="mcodeoutput|img"/>

</xsl:for-each>

<xsl:call-template name="footer"/>

</xsl:template>

<!-- Header -->
<xsl:template name="header">
</xsl:template>

<!-- Footer -->
<xsl:template name="footer">
<xsl:text>&#xa;</xsl:text>
      <xsl:value-of select="copyright"/><br/>
      <a href="http://www.mathworks.com/products/matlab/" style="font-size: 0.7em">Published with MATLAB&reg; R<xsl:value-of select="release"/></a><br/>
</xsl:template>

<!-- Contents -->
<xsl:template name="contents">
</xsl:template>


<!-- HTML Tags in text sections -->
<xsl:template match="p">
  <p><xsl:apply-templates/></p>
</xsl:template>
<xsl:template match="ul">
  <div><ul><xsl:apply-templates/></ul></div>
</xsl:template>
<xsl:template match="ol">
  <div><ol><xsl:apply-templates/></ol></div>
</xsl:template>
<xsl:template match="li">
  <li><xsl:apply-templates/></li>
</xsl:template>
<xsl:template match="pre">
  <xsl:choose>
    <xsl:when test="@class='error'">
      <pre class="error"><xsl:apply-templates/></pre>
    </xsl:when>
    <xsl:otherwise>
      <pre><xsl:apply-templates/></pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="b">
  <b><xsl:apply-templates/></b>
</xsl:template>
<xsl:template match="i">
  <i><xsl:apply-templates/></i>
</xsl:template>
<xsl:template match="tt">
  <tt><xsl:apply-templates/></tt>
</xsl:template>
<xsl:template match="a">
  <a>
    <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>
<xsl:template match="html">
    <xsl:value-of select="@text" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="latex"/>

<!-- Detecting M-Code in Comments-->
<xsl:template match="text/mcode-xmlized">
  <pre class="language-matlab"><xsl:apply-templates/><xsl:text><!-- g162495 -->
</xsl:text></pre>
</xsl:template>

<!-- Code input and output -->

<xsl:template match="mcode-xmlized">
{% highlight matlab %}
<xsl:apply-templates/>
{% endhighlight %}
</xsl:template>

<xsl:template match="mcodeoutput">
  <xsl:choose>
    <xsl:when test="concat(substring(.,0,7),substring(.,string-length(.)-7,7))='&lt;html&gt;&lt;/html&gt;'">
      <xsl:value-of select="substring(.,7,string-length(.)-14)" disable-output-escaping="yes"/>
    </xsl:when>
    <xsl:otherwise>
{% highlight matlab %}
<xsl:apply-templates/>
{% endhighlight %}
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Figure and model snapshots and equations -->
<xsl:template match="img[@class='equation']">
  <xsl:text>&#xa;</xsl:text>
  <img>
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
  </img>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template match="img">
  <xsl:text>&#xa;</xsl:text>
  <img>
    <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
    <xsl:text> </xsl:text>
  </img>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<!-- Stash original code in HTML for easy slurping later. -->

<xsl:template match="originalCode"></xsl:template>

<!-- Footer information -->

<xsl:template match="copyright">
  <xsl:value-of select="."/>
</xsl:template>
<xsl:template match="revision">
  <xsl:value-of select="."/>
</xsl:template>

<!-- Search and replace  -->
<!-- From http://www.xml.com/lpt/a/2002/06/05/transforming.html -->

<xsl:template name="globalReplace">
  <xsl:param name="outputString"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($outputString,$target)">
      <xsl:value-of select=
        "concat(substring-before($outputString,$target),$replacement)"/>
      <xsl:call-template name="globalReplace">
        <xsl:with-param name="outputString" 
          select="substring-after($outputString,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replacement" 
          select="$replacement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$outputString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
