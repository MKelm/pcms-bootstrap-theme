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
      <xsl:when test="$level = 1 and count(mapitem) &gt; 0">
        <xsl:attribute name="class">dropdown</xsl:attribute>
      </xsl:when>
      <xsl:when test="$level = 1 and @focus">
        <xsl:attribute name="class">active</xsl:attribute>
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
      <xsl:variable name="parent" select="." />
      <ul class="dropdown-menu">
        <xsl:for-each select="mapitem">
          <xsl:if test="position() = 1">
            <li>
              <xsl:if test="$parent/@focus">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a href="{$parent/@href}"><xsl:call-template name="language-text">
              <xsl:with-param name="text" select="'NAVIGATION_OVERVIEW_PAGE'" />
            </xsl:call-template></a></li>
            <li class="divider"><xsl:text> </xsl:text></li>
          </xsl:if>
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

<xsl:template name="alert">
  <xsl:param name="type" />
  <xsl:param name="message" />
  <xsl:param name="title" select="false()"/>
  <xsl:param name="useLanguageText" select="false()" />

  <xsl:if test="$message and $message != ''">
    <div class="alert">
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$type = 'error'">alert alert-error</xsl:when>
          <xsl:when test="$type = 'success'">alert alert-success</xsl:when>
          <xsl:when test="$message/@type = 'error'">alert alert-error</xsl:when>
          <xsl:when test="$message/@type = 'success'">alert alert-success</xsl:when>
          <xsl:otherwise>alert alert-info</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      <xsl:choose>
        <xsl:when test="$useLanguageText or $message/@use-language-text = 'yes'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text" select="$message"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$message" /></xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>