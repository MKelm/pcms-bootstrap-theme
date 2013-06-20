<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="content-area">
    <xsl:param name="pageContent" select="content/topic"/>

    <xsl:if test="$pageContent">
      <xsl:choose>
        <xsl:when test="$pageContent/@module = 'content_imgtopic'">
          <xsl:call-template name="module-content-topic">
            <xsl:with-param name="pageContent" select="$pageContent"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pageContent/@module = 'content_categimg'">
          <xsl:call-template name="module-content-category">
            <xsl:with-param name="pageContent" select="$pageContent"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-topic">
    <xsl:param name="pageContent"/>
    <xsl:param name="subTitle" select="false()" />
    <xsl:param name="withText" select="true()"/>
    <xsl:param name="withHook" select="false()" />
    <xsl:param name="useImageWithoutAlign" select="false()" />

    <div class="hero-unit">
      <xsl:choose>
        <xsl:when test="$pageContent/image[@align='right']//img">
          <img class="hero-image thumbnail pull-right">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
        <xsl:when test="$pageContent/image[@align='left']//img">
          <img class="hero-image thumbnail pull-left">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
        <xsl:when test="$useImageWithoutAlign and $pageContent/image">
          <img class="hero-image thumbnail pull-left" src="{$pageContent/image}" alt="" />
        </xsl:when>
      </xsl:choose>

      <h1>
        <xsl:if test="$withHook">
          <xsl:attribute name="class">pull-left</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$pageContent/title"/>
        <xsl:if test="$pageContent/subtitle != '' or $subTitle != false()">
          <xsl:text> </xsl:text>
          <small><xsl:choose>
            <xsl:when test="$subTitle != false()"><xsl:value-of select="$subtitle" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$pageContent/subtitle"/></xsl:otherwise>
          </xsl:choose></small>
        </xsl:if>
      </h1>

      <xsl:if test="$withHook">
        <xsl:call-template name="inner-content-hook">
          <xsl:with-param name="additionalCssClass" select="'pull-right'" />
        </xsl:call-template>
        <xsl:call-template name="float-fix" />
      </xsl:if>

      <xsl:if test="$withText != false()">
        <xsl:choose>
          <xsl:when test="$pageContent/text-raw">
            <!-- use raw text node -->
            <xsl:copy-of select="$pageContent/text/node()" />
          </xsl:when>
          <xsl:when test="$withText != true()">
            <!-- with text has custom text node -->
            <xsl:apply-templates select="$withText" />
          </xsl:when>
          <xsl:otherwise>
            <!-- use default text node -->
            <xsl:apply-templates select="$pageContent/text/*|$pageContent/text/text()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:call-template name="module-content-topic-additional-content-area">
        <xsl:with-param name="pageContent" select="$pageContent" />
      </xsl:call-template>
      <xsl:call-template name="float-fix" />
    </div>
  </xsl:template>

  <xsl:template name="module-content-topic-additional-content-area">
    <xsl:param name="pageContent" />
  </xsl:template>

  <!-- category content module -->
  <xsl:template name="module-content-category">
    <xsl:param name="pageContent"/>
    <xsl:call-template name="module-content-topic">
      <xsl:with-param name="pageContent" select="$pageContent" />
    </xsl:call-template>
    <xsl:if test="count($pageContent/subtopics/subtopic) &gt; 0">
      <div class="category">
        <xsl:variable name="columnCount">
          <xsl:choose>
            <xsl:when test="$pageContent/columns/text() &gt; 3">3</xsl:when>
            <xsl:when test="$pageContent/columns/text() &gt; 1"><xsl:value-of select="$pageContent/columns"/></xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="module-content-category-rows">
          <xsl:with-param name="elements" select="$pageContent/subtopics/subtopic" />
          <xsl:with-param name="rows" select="ceiling(count($pageContent/subtopics/subtopic) div $columnCount)" />
          <xsl:with-param name="columns" select="$columnCount" />
        </xsl:call-template>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-category-rows">
    <xsl:param name="elements" />
    <xsl:param name="row" select="'1'" />
    <xsl:param name="rows" />
    <xsl:param name="columns" />
    <xsl:param name="position" select="'1'" />

    <xsl:if test="$position = 1 or ($position mod $columns = 1)">
      <div class="row-fluid">
        <xsl:call-template name="module-content-category-rows-column">
          <xsl:with-param name="elements" select="$elements" />
          <xsl:with-param name="columns" select="$columns" />
          <xsl:with-param name="position" select="$position" />
          <xsl:with-param name="row" select="$row" />
        </xsl:call-template>
      </div>
    </xsl:if>

    <xsl:if test="$row &lt; $rows">
      <xsl:call-template name="module-content-category-rows">
        <xsl:with-param name="elements" select="$elements" />
        <xsl:with-param name="rows" select="$rows" />
        <xsl:with-param name="row" select="$row + 1" />
        <xsl:with-param name="columns" select="$columns" />
        <xsl:with-param name="position" select="$position + $columns" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-category-rows-column">
    <xsl:param name="elements" />
    <xsl:param name="columns" />
    <xsl:param name="position" />
    <xsl:param name="row" />

    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$columns = 1">topic span12</xsl:when>
          <xsl:when test="$columns = 2">topic span6</xsl:when>
          <xsl:when test="$columns = 3">topic span4</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$elements[position() = $position]/image">
        <xsl:variable name="topicNo" select="$elements[position() = $position]/@no" />
        <img src="{/page/content/topic/subtopicthumbs/thumb[@topic = $topicNo]/img/@src}"
          alt="" class="thumbnail pull-left" />
      </xsl:if>
      <h2>
        <a href="{$elements[position() = $position]/@href}"><xsl:value-of select="$elements[position() = $position]/title" /></a>
        <xsl:if test="$elements[position() = $position]/subtitle">
          <xsl:text> </xsl:text><small><xsl:value-of select="$elements[position() = $position]/subtitle" /></small>
        </xsl:if>
      </h2>
      <xsl:apply-templates select="$elements[position() = $position]/text" />
    </div>

    <xsl:if test="$position div $columns &lt; $row">
      <xsl:call-template name="module-content-category-rows-column">
        <xsl:with-param name="elements" select="$elements" />
        <xsl:with-param name="columns" select="$columns" />
        <xsl:with-param name="position" select="$position + 1" />
        <xsl:with-param name="row" select="$row" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>