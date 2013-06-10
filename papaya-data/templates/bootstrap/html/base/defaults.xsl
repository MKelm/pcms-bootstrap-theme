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
            <xsl:for-each select="$boxes/box[@group = 'header-navigation']">
              <xsl:value-of select="." disable-output-escaping="yes" />
            </xsl:for-each>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="sidebar-navigation">
    <xsl:param name="boxes" />

    <div class="sidebar-nav well">
      <ul class="nav nav-list">
        <xsl:for-each select="$boxes/box[@group = 'sidebar-navigation']">
          <xsl:if test="@title and @title != ''">
            <li class="nav-header"><xsl:value-of select="@title" /></li>
          </xsl:if>
          <xsl:value-of select="." disable-output-escaping="yes" />
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="sidebar">
    <xsl:param name="boxes" />
    <xsl:param name="boxGroupPostfix" select="''" />

    <xsl:variable name="boxGroupName">
      <xsl:choose>
        <xsl:when test="$boxGroupPostfix != ''">sidebar-<xsl:value-of select="$boxGroupPostfix" /></xsl:when>
        <xsl:otherwise>sidebar</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="$boxes/box[@group = $boxGroupName]">
      <div class="sidebar-box">
        <xsl:if test="@title and @title != ''">
          <h4><xsl:value-of select="@title" /></h4>
        </xsl:if>
        <xsl:value-of select="." disable-output-escaping="yes" />
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="additional">
    <xsl:param name="boxes" />
    <xsl:param name="boxGroupPostfix" select="''" />

    <xsl:variable name="boxGroupName">
      <xsl:choose>
        <xsl:when test="$boxGroupPostfix != ''">additional-<xsl:value-of select="$boxGroupPostfix" /></xsl:when>
        <xsl:otherwise>additional</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="$boxes/box[@group = $boxGroupName]">
      <div class="additional-box">
        <xsl:if test="@title and @title != ''">
          <h4><xsl:value-of select="@title" /></h4>
        </xsl:if>
        <xsl:value-of select="." disable-output-escaping="yes" />
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="before-content-hook-before">
    <xsl:param name="pageContent" />
    <!-- overwrite this template to hook contents before before-content -->
  </xsl:template>

  <xsl:template name="before-content-hook-after">
    <xsl:param name="pageContent" />
    <!-- overwrite this template to hook contents after before-content -->
  </xsl:template>

  <xsl:template name="before-content">
    <xsl:param name="boxes" />
    <xsl:param name="pageContent" />

    <xsl:choose>
      <!-- three column layout: sidebar-before-content, before-content and additional-before-content -->
      <xsl:when test="count($boxes/box[@group = 'sidebar-before-content']) &gt; 0 and
      count($boxes/box[@group = 'additional-before-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span3 sidebar-before-content">
            <xsl:call-template name="sidebar">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'before-content'" />
            </xsl:call-template>
          </div>
          <div class="span6 before-content">
            <xsl:call-template name="before-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'before-content'" />
            </xsl:call-template>
            <xsl:call-template name="before-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
          <div class="span3 additional-before-content">
            <xsl:call-template name="additional">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'before-content'" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two column layout: sidebar-before-content and before-content -->
      <xsl:when test="count($boxes/box[@group = 'sidebar-before-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span3 sidebar-before-content">
            <xsl:call-template name="sidebar">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'before-content'" />
            </xsl:call-template>
          </div>
          <div class="span9 before-content">
            <xsl:call-template name="before-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'before-content'" />
            </xsl:call-template>
            <xsl:call-template name="before-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two column layout: before-content and additional-before-content -->
      <xsl:when test="count($boxes/box[@group = 'additional-before-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span9 before-content">
            <xsl:call-template name="before-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'before-content'" />
            </xsl:call-template>
            <xsl:call-template name="before-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
          <div class="span3 additional-before-content">
            <xsl:call-template name="additional">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'before-content'" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- one column layout: before-content -->
      <xsl:otherwise>
        <div class="before-content">
          <xsl:call-template name="before-content-hook-before">
            <xsl:with-param name="pageContent" select="$pageContent" />
          </xsl:call-template>
          <xsl:call-template name="fluid-box-groups">
            <xsl:with-param name="boxes" select="$boxes" />
            <xsl:with-param name="boxGroupPrefix" select="'before-content'" />
          </xsl:call-template>
          <xsl:call-template name="before-content-hook-after">
            <xsl:with-param name="pageContent" select="$pageContent" />
          </xsl:call-template>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="after-content-hook-before">
    <xsl:param name="pageContent" />
    <!-- overwrite this template to hook contents before after-content -->
  </xsl:template>

  <xsl:template name="after-content-hook-after">
    <xsl:param name="pageContent" />
    <!-- overwrite this template to hook contents after after-content -->
  </xsl:template>

  <xsl:template name="after-content">
    <xsl:param name="boxes" />
    <xsl:param name="pageContent" />

    <xsl:choose>
      <!-- three columns layout: sidebar-after-content, after-content and additional-after-content -->
      <xsl:when test="count($boxes/box[@group = 'sidebar-after-content']) &gt; 0 and
      count($boxes/box[@group = 'additional-after-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span3 sidebar-after-content">
            <xsl:call-template name="sidebar">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'after-content'" />
            </xsl:call-template>
          </div>
          <div class="span6 after-content">
            <xsl:call-template name="after-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'after-content'" />
            </xsl:call-template>
            <xsl:call-template name="after-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
          <div class="span3 additional-after-content">
            <xsl:call-template name="additional">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'after-content'" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two columns layout: sidebar-after-content and after-content -->
      <xsl:when test="count($boxes/box[@group = 'sidebar-after-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span3 sidebar-after-content">
            <xsl:call-template name="sidebar">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'after-content'" />
            </xsl:call-template>
          </div>
          <div class="span9 after-content">
            <xsl:call-template name="after-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'after-content'" />
            </xsl:call-template>
            <xsl:call-template name="after-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two columns layout: after-content and additional-after-content -->
      <xsl:when test="count($boxes/box[@group = 'additional-after-content']) &gt; 0">
        <div class="row-fluid">
          <div class="span9 after-content">
            <xsl:call-template name="after-content-hook-before">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
            <xsl:call-template name="fluid-box-groups">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPrefix" select="'after-content'" />
            </xsl:call-template>
            <xsl:call-template name="after-content-hook-after">
              <xsl:with-param name="pageContent" select="$pageContent" />
            </xsl:call-template>
          </div>
          <div class="span3 additional-after-content">
            <xsl:call-template name="additional">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="boxGroupPostfix" select="'after-content'" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- one column layout: after-content -->
      <xsl:otherwise>
        <div class="after-content">
          <xsl:call-template name="after-content-hook-before">
            <xsl:with-param name="pageContent" select="$pageContent" />
          </xsl:call-template>
          <xsl:call-template name="fluid-box-groups">
            <xsl:with-param name="boxes" select="$boxes" />
            <xsl:with-param name="boxGroupPrefix" select="'after-content'" />
          </xsl:call-template>
          <xsl:call-template name="after-content-hook-after">
            <xsl:with-param name="pageContent" select="$pageContent" />
          </xsl:call-template>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="fluid-box-group-with-titles">
    <xsl:param name="boxes" />
    <xsl:param name="groupName" />

    <xsl:for-each select="$boxes/box[@group = $groupName]">
      <xsl:if test="@title and @title != ''">
        <h2><xsl:value-of select="@title" /></h2>
      </xsl:if>
      <xsl:value-of select="." disable-output-escaping="yes" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="fluid-box-groups">
    <xsl:param name="boxes" />
    <xsl:param name="boxGroupPrefix" />

    <xsl:choose>
      <!-- three column layout : left, middle, right -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-left')]) &gt; 0 and
      count($boxes/box[@group = concat($boxGroupPrefix, '-middle')]) &gt; 0 and
      count($boxes/box[@group = concat($boxGroupPrefix, '-right')]) &gt; 0">
        <div class="row-fluid">
          <div class="span4 fluid-left">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-left')" />
            </xsl:call-template>
          </div>
          <div class="span4 fluid-middle">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-middle')" />
            </xsl:call-template>
          </div>
          <div class="span4 fluid-right">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-right')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two column layout : left, right -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-left')]) &gt; 0 and
      count($boxes/box[@group = concat($boxGroupPrefix, '-right')]) &gt; 0">
        <div class="row-fluid">
          <div class="span6 fluid-left">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-left')" />
            </xsl:call-template>
          </div>
          <div class="span6 fluid-right">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-right')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two column layout : left, middle -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-left')]) &gt; 0 and
      count($boxes/box[@group = concat($boxGroupPrefix, '-middle')]) &gt; 0">
        <div class="row-fluid">
          <div class="span6 fluid-left">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-left')" />
            </xsl:call-template>
          </div>
          <div class="span6 fluid-right">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-middle')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- two column layout : middle, right -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-middle')]) &gt; 0 and
      count($boxes/box[@group = concat($boxGroupPrefix, '-right')]) &gt; 0">
        <div class="row-fluid">
          <div class="span6 fluid-left">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-middle')" />
            </xsl:call-template>
          </div>
          <div class="span6 fluid-right">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-right')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- one column layout : middle -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-middle')]) &gt; 0">
        <div class="row-fluid">
          <div class="span12 fluid-middle">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-middle')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- one column layout : left -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-left')]) &gt; 0">
        <div class="row-fluid fluid-middle">
          <div class="span12">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-left')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
      <!-- one column layout : right -->
      <xsl:when test="count($boxes/box[@group = concat($boxGroupPrefix, '-right')]) &gt; 0">
        <div class="row-fluid fluid-middle">
          <div class="span12">
            <xsl:call-template name="fluid-box-group-with-titles">
              <xsl:with-param name="boxes" select="$boxes" />
              <xsl:with-param name="groupName" select="concat($boxGroupPrefix, '-right')" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- call this template in your page content to hook in inner content boxes -->
  <xsl:template name="inner-content-hook">
    <xsl:param name="additionalCssClass" select="false()" />
    <xsl:if test="count(/page/boxes/box[@group = 'inner-content']) &gt; 0">
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$additionalCssClass != false()">
              <xsl:text>inner-content </xsl:text><xsl:value-of select="$additionalCssClass" />
            </xsl:when>
            <xsl:otherwise>inner-content</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:for-each select="/page/boxes/box[@group = 'inner-content']">
          <xsl:value-of select="." disable-output-escaping="yes" />
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="content">
    <xsl:call-template name="before-content">
      <xsl:with-param name="boxes" select="boxes" />
      <xsl:with-param name="pageContent" select="content/topic" />
    </xsl:call-template>
    <div class="content-area">
      <xsl:call-template name="content-area">
        <xsl:with-param name="pageContent" select="content/topic" />
      </xsl:call-template>
    </div>
    <xsl:call-template name="after-content">
      <xsl:with-param name="boxes" select="boxes" />
      <xsl:with-param name="pageContent" select="content/topic" />
    </xsl:call-template>
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
          <xsl:choose>
            <!-- three column layout : sidebar(-navigation), content, additional -->
            <xsl:when test="(count(boxes/box[@group = 'sidebar-navigation']) &gt; 0 or
              count(boxes/box[@group = 'sidebar']) &gt; 0) and
            count(boxes/box[@group = 'additional']) &gt; 0">
              <div class="row-fluid">
                <div class="span3 sidebar">
                  <xsl:call-template name="sidebar-navigation">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                  <xsl:call-template name="sidebar">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                </div>
                <div class="span6 content">
                  <xsl:call-template name="content" />
                </div>
                <div class="span3 additional">
                  <xsl:call-template name="additional">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                </div>
              </div>
            </xsl:when>
            <!-- two column layout : sidebar(-navigation), content -->
            <xsl:when test="count(boxes/box[@group = 'sidebar-navigation']) &gt; 0 or
            count(boxes/box[@group = 'sidebar']) &gt; 0">
              <div class="row-fluid">
                <div class="span3 sidebar">
                  <xsl:call-template name="sidebar-navigation">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                  <xsl:call-template name="sidebar">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                </div>
                <div class="span9 content">
                  <xsl:call-template name="content" />
                </div>
              </div>
            </xsl:when>
            <!-- two column layout : content, additional -->
            <xsl:when test="count(boxes/box[@group = 'additional']) &gt; 0">
              <div class="row-fluid">
                <div class="span9 content">
                  <xsl:call-template name="content" />
                </div>
                <div class="span3 additional">
                  <xsl:call-template name="additional">
                    <xsl:with-param name="boxes" select="boxes" />
                  </xsl:call-template>
                </div>
              </div>
            </xsl:when>
            <!-- single column layout: content -->
            <xsl:otherwise>
              <div class="row-fluid">
                <div class="span12 content">
                  <xsl:call-template name="content" />
                </div>
              </div>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="footer" />
        </div>
        <xsl:call-template name="papaya-scripts-lazy" />
        <xsl:call-template name="page-scripts-lazy" />
      </body>
    </html>
  </xsl:template>

  <xsl:template name="footer">
    <hr />
    <p class="copyright"><xsl:call-template name="copyright" /></p>
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
    </xsl:call-template><xsl:text> </xsl:text><a href="http://mkelm.github.io">papaya CMS</a>
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
      <xsl:with-param name="file">js/html5shiv.min.js</xsl:with-param>
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