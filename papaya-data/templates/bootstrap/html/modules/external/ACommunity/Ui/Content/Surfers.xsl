<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="acommunity-surfers">
    <xsl:param name="content" />
    <xsl:param name="withFilter" select="false()" />
    <xsl:param name="withSearch" select="false()" />
    <xsl:param name="withGrid" select="false()" />

    <xsl:if test="$withFilter">
      <xsl:call-template name="acommunity-surfers-filter-navigation">
        <xsl:with-param name="content" select="$content/filter-navigation" />
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$withSearch">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$content/search/dialog-box" />
        <xsl:with-param name="search" select="true()" />
        <xsl:with-param name="inputSize" select="'xxlarge'" />
        <xsl:with-param name="showButtons" select="false()" />
        <xsl:with-param name="class" select="'surfers-search-dialog'" />
      </xsl:call-template>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="count($content/group) &gt; 0">
        <div class="row-fluid">
          <xsl:for-each select="$content/group">
            <div class="span4">
              <a name="{@name}"><xsl:text> </xsl:text></a>
              <h2><xsl:value-of select="@caption" /></h2>
              <xsl:call-template name="acommunity-surfers-list">
                <xsl:with-param name="surfers" select="surfer" />
                <xsl:with-param name="message" select="message" />
              </xsl:call-template>
              <xsl:call-template name="acommunity-content-paging">
                <xsl:with-param name="paging" select="paging" />
              </xsl:call-template>
            </div>
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:when test="$withGrid">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$content/message" />
        </xsl:call-template>
        <xsl:if test="count($content/surfer) &gt; 0">
          <xsl:call-template name="acommunity-surfers-row">
            <xsl:with-param name="surfers" select="$content/surfer" />
          </xsl:call-template>
          <xsl:call-template name="acommunity-content-paging">
            <xsl:with-param name="paging" select="$content/paging" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="acommunity-surfers-list">
          <xsl:with-param name="surfers" select="$content/surfer" />
          <xsl:with-param name="message" select="$content/message" />
        </xsl:call-template>
        <xsl:call-template name="acommunity-content-paging">
          <xsl:with-param name="paging" select="$content/paging" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="acommunity-surfers-filter-navigation">
    <xsl:param name="content" />

    <xsl:if test="$content">
      <ul class="nav nav-pills surfers-filter">
        <xsl:for-each select="$content/character">
          <li><a href="{@href}"><xsl:value-of select="." /></a></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="acommunity-surfers-row">
    <xsl:param name="surfers" />
    <xsl:param name="row" select="'1'" />
    <xsl:param name="columns" select="'3'" />
    <xsl:param name="position" select="'1'" />

    <xsl:if test="$position = 1 or $position mod $columns = 1">
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$position + $columns - 1 &lt; count($surfers)">row-fluid</xsl:when>
            <xsl:otherwise>row-fluid last</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="acommunity-surfers-list">
          <xsl:with-param name="surfers" select="$surfers[position() &gt; ($row - 1) * $columns and position() &lt;= $row * $columns]" />
          <xsl:with-param name="inRow" select="true()" />
          <xsl:with-param name="columns" select="$columns" />
        </xsl:call-template>
      </div>
    </xsl:if>

    <xsl:if test="$position + $columns - 1 &lt; count($surfers)">
      <xsl:call-template name="acommunity-surfers-row">
        <xsl:with-param name="surfers" select="$surfers" />
        <xsl:with-param name="row" select="$row + 1" />
        <xsl:with-param name="columns" select="$columns" />
        <xsl:with-param name="position" select="$position + $columns" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="acommunity-surfers-list">
    <xsl:param name="surfers" />
    <xsl:param name="message" select="''" />
    <xsl:param name="inRow" select="false()" />
    <xsl:param name="columns" select="false()" />

    <xsl:choose>
      <xsl:when test="$inRow">
        <xsl:for-each select="$surfers">
          <div>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="$columns = 3">span4</xsl:when>
                <xsl:when test="$columns = 2">span6</xsl:when>
                <xsl:when test="$columns = 1">span12</xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="acommunity-surfers-surfer">
              <xsl:with-param name="surfer" select="." />
            </xsl:call-template>
          </div>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count($surfers) &gt; 0">
        <xsl:for-each select="$surfers">
          <xsl:call-template name="acommunity-surfers-surfer">
            <xsl:with-param name="surfer" select="." />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$message and $message != ''">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$message" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="acommunity-surfers-surfer">
    <xsl:param name="surfer" />

    <div class="media surfer">
      <a class="pull-left" href="{$surfer/@page-link}"><img class="media-object" alt="" src="{$surfer/@avatar}" /></a>
      <div class="media-body">
        <h4 class="media-heading"><a href="{$surfer/@page-link}"><xsl:value-of select="$surfer/@name" /></a></h4>
        <p>
          <xsl:if test="$surfer/last-time">
            <div class="last-time">
              <xsl:value-of select="$surfer/last-time/@caption" />:
              <xsl:text> </xsl:text>
              <xsl:call-template name="format-date-time">
                <xsl:with-param name="dateTime" select="$surfer/last-time" />
              </xsl:call-template>
            </div>
          </xsl:if>
          <xsl:if test="count($surfer/command) &gt; 0">
            <div class="commands">
              <xsl:for-each select="$surfer/command">
                <xsl:if test="position() &gt; 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <span class="command"><a href="{text()}"><xsl:value-of select="@caption" /></a></span>
              </xsl:for-each>
            </div>
          </xsl:if>
        </p>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>