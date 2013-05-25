<?xml version="1.0"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:str="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="func str exsl">

<!--
  IMPORTANT! DO NOT CHANGE THIS FILE!

  If you need to change one of the templates just define a template with the
  same name in your xsl file. This will override the imported template from
  this file.

  This file contains
   - global parameters passed by papaya CMS
   - global variables that one can override to change how the template set
     behaves
   - some named templates you likely don't need to override.
-->

<!-- localisation -->
<xsl:import href="../../_lang/language.xsl" />

<!-- match templates -->
<xsl:import href="./match.xsl" />
<!-- column layouts -->
<xsl:import href="./columns.xsl" />
<!-- list layouts -->
<xsl:import href="./lists.xsl" />
<!-- dialog (form) layouts -->
<xsl:import href="./dialogs.xsl" />
<!-- paging (if data is splitted into several pages) -->
<xsl:import href="./paging.xsl" />

<!--
  papaya CMS parameters
-->

<!-- page title (like in navigations) -->
<xsl:param name="PAGE_TITLE" />
<!-- content language (example: en-US) -->
<xsl:param name="PAGE_LANGUAGE" />
<!-- base installation path in browser -->
<xsl:param name="PAGE_WEB_PATH" />
<!-- base url of the papaya installation -->
<xsl:param name="PAGE_BASE_URL" />
<!-- url of this page -->
<xsl:param name="PAGE_URL" />
<!-- theme name -->
<xsl:param name="PAGE_THEME" />
<!-- theme set id if defined -->
<xsl:param name="PAGE_THEME_SET">0</xsl:param>
<!-- theme path in browser -->
<xsl:param name="PAGE_THEME_PATH" />
<!-- theme path in server file system -->
<xsl:param name="PAGE_THEME_PATH_LOCAL" />

<!-- current ouput mode (file extension in url) -->
<xsl:param name="PAGE_OUTPUTMODE_CURRENT" />
<!-- default/main ouput mode -->
<xsl:param name="PAGE_OUTPUTMODE_DEFAULT" />
<!-- public or preview page? -->
<xsl:param name="PAGE_MODE_PUBLIC" />
<!-- website version string if available -->
<xsl:param name="PAGE_WEBSITE_REVISION" />

<!-- papaya cms version string if available -->
<xsl:param name="PAPAYA_VERSION" />
<!-- installation in dev mode? (option in conf.inc.php) -->
<xsl:param name="PAPAYA_DBG_DEVMODE" />

<!-- current local time and offset from UTC -->
<xsl:param name="SYSTEM_TIME" />
<xsl:param name="SYSTEM_TIME_OFFSET" />

<!--
  template set parameters
-->

<!-- use favicon.ico in theme directory -->
<xsl:param name="FAVORITE_ICON" select="true()" />

<!-- IE only, disable the mouseover image toolbar, default: true -->
<xsl:param name="IE_DISABLE_IMAGE_TOOLBAR" select="true()" />
<!-- IE only, disable the smart tag linking, default: true -->
<xsl:param name="IE_DISABLE_SMARTTAGS" select="true()" />
<!-- IE only, optional user agent compatibility definition, default: not used -->
<xsl:param name="USER_AGENT_COMPATIBILITY"></xsl:param>

<!-- define indexing for robots -->
<xsl:param name="PAGE_META_ROBOTS">index,follow</xsl:param>
<!-- define indexing for robots if a box suggests content dupplication-->
<xsl:param name="PAGE_META_ROBOTS_DUPLICATES">noindex,nofollow,nocache</xsl:param>

<!-- add css classes to boxes based on the module class name -->
<xsl:param name="BOX_MODULE_CSSCLASSES" select="false()" />
<!-- load file containing module specific css files name definitions -->
<xsl:param name="BOX_MODULE_FILES" select="false()" />
<!-- do not index box output (puts noindex comments around it) -->
<xsl:param name="BOX_DISABLE_INDEX" select="true()" />

<!-- disable the navigation column, even if the xml contains boxes for it -->
<xsl:param name="DISABLE_NAVIGATION_COLUMN" select="false()" />
<!-- disable the additional content column, even if the xml contains boxes for it -->
<xsl:param name="DISABLE_ADDITIONAL_COLUMN" select="false()" />

<!--
  template definitions
-->
<xsl:key name="box-modules" match="/page/boxes/box" use="@module"/>

<func:function name="func:getWebsiteRevision">
  <xsl:param name="encoded" select="false()"/>
  <xsl:variable name="result">
    <xsl:choose>
      <xsl:when test="$encoded">
        <xsl:value-of select="str:encode-uri($PAGE_WEBSITE_REVISION, true())"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$PAGE_WEBSITE_REVISION"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <func:result select="string($result)"/>
</func:function>

<!-- page title -->
<xsl:template name="page-title">
  <xsl:choose>
    <xsl:when test="meta/metatags/pagetitle/text() != '' and $PAGE_TITLE != '' and meta/metatags/pagetitle/text() != $PAGE_TITLE">
      <xsl:value-of select="meta/metatags/pagetitle/text()"/> - <xsl:value-of select="$PAGE_TITLE" />
    </xsl:when>
    <xsl:when test="$PAGE_TITLE != ''">
      <xsl:value-of select="$PAGE_TITLE" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="meta/metatags/pagetitle/text()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- meta tags list -->
<xsl:template name="page-metatags">
  <xsl:param name="metaTags" select="meta/metatags"/>
  <xsl:if test="$metaTags/metatag[@type='date'] != ''">
    <meta name="date" content="{$metaTags/metatag[@type='date']}" />
  </xsl:if>
  <xsl:if test="$metaTags/metatag[@type='keywords'] != ''">
    <meta name="keywords" content="{$metaTags/metatag[@type='keywords']}" />
  </xsl:if>
  <xsl:if test="$metaTags/metatag[@type='description'] != ''">
    <meta name="description" content="{$metaTags/metatag[@type='description']}" />
  </xsl:if>
  <xsl:choose>
    <xsl:when test="/page/boxes/box/attributes/attribute[@name = 'noIndex' and @value = 'yes']">
      <meta name="robots" content="{$PAGE_META_ROBOTS_DUPLICATES}" />
    </xsl:when>
    <xsl:when test="$PAGE_META_ROBOTS != ''">
      <meta name="robots" content="{$PAGE_META_ROBOTS}" />
    </xsl:when>
  </xsl:choose>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</xsl:template>

<!--
  content area template- checks for modules and calls the matching template
  you need to redefine that template for own content modules
 -->
<xsl:template name="content-area">
  <xsl:param name="pageContent" select="content/topic"/>

</xsl:template>

<xsl:template name="papaya-styles-boxes">
  <xsl:call-template name="link-style">
    <xsl:with-param name="files" select="func:getModuleThemeFiles($BOX_MODULE_FILES/boxes/styles/*[name() = 'file' or name() = 'css'])"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="papaya-scripts-boxes">
  <xsl:call-template name="link-script">
    <xsl:with-param name="files" select="func:getModuleThemeFiles($BOX_MODULE_FILES/boxes/scripts/file)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="papaya-scripts-boxes-lazy">
  <xsl:call-template name="link-script">
    <xsl:with-param name="files" select="func:getModuleThemeFiles($BOX_MODULE_FILES/boxes/scripts-lazy/file)"/>
  </xsl:call-template>
</xsl:template>

<func:function name="func:getModuleThemeFiles">
  <xsl:param name="files"/>
  <xsl:variable name="xml">
    <xsl:if test="$files">
      <xsl:variable name="modules" select="/page/boxes/box[generate-id(.) = generate-id(key('box-modules', @module)[1])]/@module"/>
      <xsl:for-each select="$modules">
        <xsl:sort select="." />
        <xsl:variable name="currentModule" select="."/>
        <xsl:for-each select="$files[@module = $currentModule]">
          <xsl:if test="@file and @file != ''">
            <file><xsl:value-of select="@file"/></file>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="sorted">
    <xsl:for-each select="exsl:node-set($xml)/*">
      <xsl:sort select="."/>
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="result">
    <xsl:variable name="nodes" select="exsl:node-set($sorted)/*"/>
    <xsl:for-each select="$nodes">
      <xsl:variable name="currentPosition" select="position()"/>
      <xsl:variable name="previousPosition" select="position() -1"/>
      <xsl:choose>
        <xsl:when test="string(.) != string($nodes[$previousPosition])">
          <xsl:copy-of select="."/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  <func:result select="$result"/>
</func:function>

<xsl:template name="papaya-styles">
  <xsl:call-template name="link-style">
    <xsl:with-param name="files">
      <file>css/bootstrap.min.css</file>
      <file>css/custom.css</file>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="papaya-styles-boxes" />
</xsl:template>

<xsl:template name="papaya-scripts">
  <xsl:call-template name="papaya-scripts-boxes" />
</xsl:template>

<xsl:template name="papaya-scripts-lazy">
  <xsl:call-template name="link-script">
    <xsl:with-param name="files">
      <file>js/jquery-2.0.1.min.js</file>
      <file>js/bootstrap.min.js</file>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="papaya-scripts-boxes-lazy" />
</xsl:template>

<xsl:template name="link-script">
  <xsl:param name="file" />
  <xsl:param name="files">
    <file><xsl:value-of select="$file"/></file>
  </xsl:param>
  <xsl:param name="type">text/javascript</xsl:param>
  <xsl:param name="useWrapper" select="not($PAPAYA_DBG_DEVMODE)"/>
  <xsl:call-template name="link-resource">
    <xsl:with-param name="files" select="$files"/>
    <xsl:with-param name="type" select="$type"/>
    <xsl:with-param name="useWrapper" select="$useWrapper"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="link-style">
  <xsl:param name="file" />
  <xsl:param name="files">
    <file><xsl:value-of select="$file"/></file>
  </xsl:param>
  <xsl:param name="media">screen, projection</xsl:param>
  <xsl:param name="useWrapper" select="not($PAPAYA_DBG_DEVMODE)"/>
  <xsl:call-template name="link-resource">
    <xsl:with-param name="files" select="$files"/>
    <xsl:with-param name="type">text/css</xsl:with-param>
    <xsl:with-param name="media" select="$media"/>
    <xsl:with-param name="useWrapper" select="$useWrapper"/>
  </xsl:call-template>
</xsl:template>

<!--  embed resources, css and javascript -->

<xsl:template name="link-resource">
  <xsl:param name="files"/>
  <xsl:param name="type">text/css</xsl:param>
  <xsl:param name="media">screen, projection</xsl:param>
  <xsl:param name="useWrapper" select="false()"/>
  <xsl:choose>
    <xsl:when test="exsl:object-type($files) = 'RTF'">
      <xsl:call-template name="link-resource">
        <xsl:with-param name="files" select="exsl:node-set($files)/*"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="media" select="$media"/>
        <xsl:with-param name="useWrapper" select="$useWrapper"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="exsl:object-type($files) = 'node-set'">
      <xsl:if test="count($files) &gt; 0">
        <xsl:choose>
          <xsl:when test="$useWrapper">
            <xsl:variable name="wrapper">
              <xsl:choose>
                <xsl:when test="$type = 'text/javascript'">js.php</xsl:when>
                <xsl:otherwise>css.php</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="href">
              <xsl:value-of select="$PAGE_THEME_PATH"/>
              <xsl:value-of select="$wrapper"/>
              <xsl:text>?files=</xsl:text>
              <xsl:for-each select="$files">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:text>&#38;rev=</xsl:text>
              <xsl:value-of select="str:encode-uri($PAGE_WEBSITE_REVISION, true())"/>
              <xsl:if test="number($PAGE_THEME_SET) &gt; 0">
                <xsl:text>&#38;set=</xsl:text>
                <xsl:value-of select="str:encode-uri($PAGE_THEME_SET, true())"/>
              </xsl:if>
              <xsl:if test="$type != 'text/javascript'">&#38;rec=yes</xsl:if>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$type = 'text/css'">
                <link rel="stylesheet" type="text/css" href="{$href}" media="{$media}"/>
              </xsl:when>
              <xsl:otherwise>
                <script type="{$type}" src="{$href}"><xsl:comment><xsl:text> </xsl:text>//</xsl:comment></script>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$files">
              <xsl:variable name="href">
                <xsl:value-of select="$PAGE_THEME_PATH"/>
                <xsl:value-of select="."/>
                <xsl:text>?rev=</xsl:text>
                <xsl:value-of select="str:encode-uri($PAGE_WEBSITE_REVISION, true())"/>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$type = 'text/css'">
                  <link rel="stylesheet" type="text/css" href="{$href}" media="{$media}"/>
                </xsl:when>
                <xsl:otherwise>
                  <script type="{$type}" src="{$href}"><xsl:comment><xsl:text> </xsl:text>//</xsl:comment></script>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- a little div to fix floating problems (height of elements) -->
<xsl:template name="float-fix">
  <div class="clearfix"><xsl:text> </xsl:text></div>
</xsl:template>

<xsl:template name="alert">
  <xsl:param name="type" />
  <xsl:param name="message" />
  <xsl:param name="title" select="false()"/>

  <div class="alert">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$type = 'error'">alert alert-error</xsl:when>
        <xsl:when test="$type = 'success'">alert alert-success</xsl:when>
        <xsl:otherwise>alert alert-info</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <button type="button" class="close" data-dismiss="alert">&#215;</button>
    <xsl:value-of select="$message" />
  </div>
</xsl:template>

</xsl:stylesheet>