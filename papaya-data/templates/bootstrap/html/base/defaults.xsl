<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  IMPORTANT! DO NOT CHANGE THIS FILE!

  If you need to change one of the templates just define a template with the
  same name in your xsl file. This will override the imported template from
  this file.

  This file contains named templates you might want to override when customizing
  your site.
-->

<!-- basic behaviour and parameters -->
<xsl:import href="./base.xsl" />

<!--
  template definitions
-->

<xsl:template name="header-navigation">
  <xsl:param name="boxes" />

  <div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <a class="brand" href="/"><xsl:call-template name="language-text">
          <xsl:with-param name="text" select="'PROJECT_NAME'"/>
        </xsl:call-template></a>
        <div class="nav-collapse collapse">
          <xsl:for-each select="boxes/box[@group = 'header-navigation']">
            <xsl:value-of select="." disable-output-escaping="yes" />
          </xsl:for-each>
        </div>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template name="page">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
  <html lang="{$PAGE_LANGUAGE}">
    <head>
      <xsl:call-template name="html-head" />
    </head>
    <body>
      <xsl:call-template name="header-navigation">
        <xsl:with-param name="boxes" select="boxes" />
      </xsl:call-template>
      <div class="container">
        <xsl:call-template name="content-area">
          <xsl:with-param name="pageContent" select="content/topic" />
        </xsl:call-template>
        <xsl:call-template name="footer" />
      </div>
      <xsl:call-template name="page-scripts-lazy" />
      <xsl:call-template name="papaya-scripts-lazy" />
    </body>
  </html>
</xsl:template>

<xsl:template name="footer">
  <hr />
  <p><xsl:call-template name="copyright" /></p>
</xsl:template>

<xsl:template name="copyright">
  <xsl:if test="count(boxes/box[@group = 'copyright']) &gt; 0">
    <xsl:for-each select="boxes/box[@group = 'copyright']">
      <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:for-each>
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:call-template name="language-text">
    <xsl:with-param name="text" select="'POWERED_BY'"/>
  </xsl:call-template><xsl:text> </xsl:text><a href="http://www.papaya-cms.com/">papaya CMS</a>
</xsl:template>

<xsl:template name="page-views">
  <xsl:if test="count(views/viewmode[@type = 'page' and not(@selected)]) &gt; 0">
    <ul class="pageViews">
      <xsl:for-each select="views/viewmode[@type = 'page']">
        <xsl:if test="not(@selected)">
          <li>
            <xsl:choose>
              <xsl:when test="@ext = 'pdf'">
                <xsl:call-template name="page-views-link-pdf" />
              </xsl:when>
              <xsl:when test="@ext = 'print'">
                <xsl:call-template name="page-views-link-print" />
              </xsl:when>
              <xsl:otherwise>
                <a href="{@href}"><xsl:value-of select="@ext"/></a>
              </xsl:otherwise>
            </xsl:choose>
          </li>
        </xsl:if>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template name="page-views-link-pdf">
  <xsl:variable name="title">
    <xsl:call-template name="language-text">
      <xsl:with-param name="text">VIEW_CAPTION_PDF</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <a href="{@href}"><xsl:value-of select="$title"/></a>
</xsl:template>

<xsl:template name="page-views-link-print">
  <xsl:variable name="title">
    <xsl:call-template name="language-text">
      <xsl:with-param name="text">VIEW_CAPTION_PRINT</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <a href="{@href}"><xsl:value-of select="$title"/></a>
</xsl:template>

<xsl:template name="page-views-relations">
  <xsl:if test="count(views/viewmode[@type = 'feed' and not(@selected)]) &gt; 0">
    <xsl:for-each select="views/viewmode[@type = 'feed']">
      <xsl:if test="not(@selected)">
        <link rel="alternate" type="{@contenttype}" href="{@href}"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="page-translations">
  <xsl:if test="count(translations/translation) &gt; 1">
    <ul class="pageTranslations">
      <xsl:for-each select="translations/translation">
        <li>
          <xsl:if test="@selected">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{@href}" title="{text()}"><xsl:value-of select="@lng_title"/></a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template name="page-styles">
  <!-- place holder - overload in page xsl to add own styles -->
</xsl:template>

<xsl:template name="page-scripts">
  <!-- place holder - overload in page xsl to add own scripts to html head -->
</xsl:template>

<xsl:template name="page-scripts-lazy">
  <!-- place holder - overload in page xsl to add own scripts to end of html body -->
</xsl:template>

<xsl:template name="header-area">
  <!-- place holder - overload in page xsl to add stuff to end of html head -->
</xsl:template>

<xsl:template name="html-head">
  <title><xsl:call-template name="page-title"/></title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <xsl:if test="$FAVORITE_ICON">
    <link rel="shortcut icon" href="{$PAGE_THEME_PATH}favicon.ico" />
  </xsl:if>
  <xsl:if test="$IE_DISABLE_IMAGE_TOOLBAR">
    <meta http-equiv="imagetoolbar" content="false" />
  </xsl:if>
  <xsl:if test="$IE_DISABLE_SMARTTAGS">
    <meta name="MSSmartTagsPreventParsing" content="true" />
  </xsl:if>
  <xsl:if test="$USER_AGENT_COMPATIBILITY and $USER_AGENT_COMPATIBILITY != ''">
    <meta name="X-UA-Compatible" content="{$USER_AGENT_COMPATIBILITY}" />
  </xsl:if>
  <xsl:call-template name="page-metatags"/>
  <xsl:call-template name="papaya-styles" />
  <xsl:call-template name="page-styles" />
  <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;</xsl:text>
  <xsl:call-template name="link-script">
    <xsl:with-param name="file">js/html5shiv.js</xsl:with-param>
  </xsl:call-template>
  <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
  <xsl:call-template name="papaya-scripts"/>
  <xsl:call-template name="page-scripts" />
  <xsl:call-template name="page-views-relations"/>
  <xsl:call-template name="header-area"/>
  <xsl:for-each select="boxes/box[@group = 'html-head']">
    <xsl:value-of select="." disable-output-escaping="yes"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>