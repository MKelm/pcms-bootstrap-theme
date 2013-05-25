<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  IMPORTANT! DO NOT CHANGE THIS FILE!

  If you need to change one of the templates just define a template with the
  same name in your xsl file. This will override the imported template from
  this file.
-->

<xsl:import href="../../_lang/language.xsl" />

<xsl:output method="xml" encoding="UTF-8" standalone="no" indent="yes" omit-xml-declaration="yes" />

<xsl:param name="LANGUAGE_TEXTS_CURRENT" select="document(concat('../', $PAGE_LANGUAGE, '.xml'))" />
<xsl:param name="LANGUAGE_TEXTS_FALLBACK" select="document('../en-US.xml')"/>

<xsl:template name="navigation">
  <xsl:param name="sidebar" select="false()" />

  <xsl:if test="count(mapitem) &gt; 0">
    <xsl:choose>
      <xsl:when test="$sidebar = false()">
        <ul class="nav">
          <xsl:for-each select="mapitem">
            <xsl:call-template name="navigation-item" />
          </xsl:for-each>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="mapitem">
          <xsl:call-template name="navigation-item" />
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="navigation-item">
	<xsl:param name="level" select="'1'"/>

  <li>
    <xsl:choose>
      <xsl:when test="$level &gt; 1 and count(mapitem) &gt; 0 and (@focus or .//@focus)">
        <xsl:attribute name="class">dropdown-submenu active</xsl:attribute>
      </xsl:when>
      <xsl:when test="$level &gt; 1 and count(mapitem) &gt; 0">
        <xsl:attribute name="class">dropdown-submenu</xsl:attribute>
      </xsl:when>
      <xsl:when test="$level &gt; 1 and @focus">
        <xsl:attribute name="class">active</xsl:attribute>
      </xsl:when>
      <xsl:when test="$level = 1 and count(mapitem) &gt; 0 and (@focus or .//@focus)">
        <xsl:attribute name="class">dropdown active</xsl:attribute>
      </xsl:when>
    </xsl:choose>
	  <a href="{@href}">
      <!-- copy data attributes -->
      <xsl:copy-of select="@*[starts-with(name(), 'data-')]"/>
      <!-- copy target and onclick attributes -->
      <xsl:copy-of select="@target|@onclick"/>
      <xsl:choose>
        <xsl:when test="$level = 1 and count(mapitem) &gt; 0">
          <xsl:attribute name="class">dropdown-toggle</xsl:attribute>
          <xsl:attribute name="data-toggle">dropdown</xsl:attribute>
        </xsl:when>
        <xsl:when test="$level &gt; 1 and count(mapitem) &gt; 0">
          <xsl:attribute name="tabindex">-1</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="@title" />
      <xsl:if test="$level = 1 and count(mapitem) &gt; 0">
        <xsl:text> </xsl:text><b class="caret"><xsl:text> </xsl:text></b>
      </xsl:if>
    </a>
    <xsl:if test="count(mapitem) &gt; 0">
      <ul class="dropdown-menu">
        <xsl:for-each select="mapitem">
          <xsl:call-template name="navigation-item">
            <xsl:with-param name="level" select="$level + 1" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

<!-- a little div to fix floating problems (height of elements) -->
<xsl:template name="float-fix">
  <div class="clearfix"><xsl:text> </xsl:text></div>
</xsl:template>

</xsl:stylesheet>