<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="module-content-acommunity-groups-page">
    <xsl:param name="pageContent" />

    <xsl:if test="count($pageContent/commands/*) &gt; 0 or count($pageContent/modes/*) &gt; 0">
      <ul class="nav nav-tabs">
        <xsl:for-each select="$pageContent/modes/*">
          <li>
            <xsl:if test="@active = '1'">
              <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{.}"><xsl:value-of select="@caption" /></a>
          </li>
        </xsl:for-each>
        <xsl:for-each select="$pageContent/commands/*">
          <li>
            <xsl:if test="@active = '1'">
              <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{.}"><xsl:value-of select="@caption" /></a>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>

    <xsl:if test="$pageContent/dialog-box">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/dialog-box" />
        <xsl:with-param name="message" select="$pageContent/dialog-message" />
        <xsl:with-param name="horizontal" select="true()" />
        <xsl:with-param name="inputSize" select="'xxlarge'" />
        <xsl:with-param name="showMandatory" select="true()" />
      </xsl:call-template>
      <hr />
    </xsl:if>

    <xsl:call-template name="alert">
      <xsl:with-param name="message" select="$pageContent/message" />
    </xsl:call-template>

    <xsl:if test="count($pageContent/groups/group) &gt; 0">
      <xsl:call-template name="acommunity-groups-row">
        <xsl:with-param name="groups" select="$pageContent/groups/group" />
        <xsl:with-param name="columns" select="$pageContent/@groups-per-row" />
      </xsl:call-template>
      <xsl:call-template name="acommunity-content-paging">
        <xsl:with-param name="paging" select="$pageContent/groups/paging" />
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="acommunity-groups-row">
    <xsl:param name="groups" />
    <xsl:param name="row" select="'1'" />
    <xsl:param name="columns" select="'3'" />
    <xsl:param name="position" select="'1'" />

    <xsl:if test="$position = 1 or $position mod $columns = 1">
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$position + $columns - 1 &lt; count($groups)">row-fluid</xsl:when>
            <xsl:otherwise>row-fluid last</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="acommunity-groups-list">
          <xsl:with-param name="groups" select="$groups[position() &gt; ($row - 1) * $columns and position() &lt;= $row * $columns]" />
          <xsl:with-param name="columns" select="$columns" />
        </xsl:call-template>
      </div>
    </xsl:if>

    <xsl:if test="$position + $columns - 1 &lt; count($groups)">
      <xsl:call-template name="acommunity-groups-row">
        <xsl:with-param name="groups" select="$groups" />
        <xsl:with-param name="row" select="$row + 1" />
        <xsl:with-param name="columns" select="$columns" />
        <xsl:with-param name="position" select="$position + $columns" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="acommunity-groups-list">
    <xsl:param name="groups" />
    <xsl:param name="columns" select="false()" />

    <xsl:for-each select="$groups">
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$columns = 3">span4</xsl:when>
            <xsl:when test="$columns = 2">span6</xsl:when>
            <xsl:when test="$columns = 1">span12</xsl:when>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="acommunity-groups-group">
          <xsl:with-param name="group" select="." />
        </xsl:call-template>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="acommunity-groups-group">
    <xsl:param name="group" />

    <div class="media group">
      <a class="pull-left" href="{@page-link}"><img class="media-object" alt="" src="{@image}" /></a>
      <div class="media-body">
        <h4 class="media-heading">
          <xsl:choose>
            <xsl:when test="@page-link">
              <a href="{@page-link}"><xsl:value-of select="@title" /></a>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="@title" /></xsl:otherwise>
          </xsl:choose>
          <xsl:if test="@is-public">
            <xsl:choose>
              <xsl:when test="@is-public = '1'">
                <xsl:text> </xsl:text><i class="icon-eye-open"><xsl:text> </xsl:text></i>
              </xsl:when>
              <xsl:otherwise><xsl:text> </xsl:text><i class="icon-eye-close"><xsl:text> </xsl:text></i></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </h4>
        <p>
          <div class="time">
            Existiert seit:
            <xsl:text> </xsl:text>
            <xsl:call-template name="format-date">
              <xsl:with-param name="date" select="@time" />
            </xsl:call-template>
          </div>
          <xsl:if test="count(commands/edit) &gt; 0">
            <a class="btn btn-mini" href="{commands/edit}">
              <i class="icon-pencil"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/edit/@caption" /></a>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:if test="count(commands/delete) &gt; 0">
            <a class="btn btn-mini" href="{commands/delete}">
              <i class="icon-remove"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/delete/@caption" /></a>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:if test="count(commands/remove-membership) &gt; 0">
            <a class="btn btn-mini" href="{commands/remove-membership}">
              <i class="icon-remove-circle"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/remove-membership/@caption" /></a>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:if test="count(commands/accept-invitation) &gt; 0">
            <a class="btn btn-mini" href="{commands/accept-invitation}">
              <i class="icon-ok-circle"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/accept-invitation/@caption" /></a>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:if test="count(commands/decline-invitation) &gt; 0">
            <a class="btn btn-mini" href="{commands/decline-invitation}">
              <i class="icon-remove-circle"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/decline-invitation/@caption" /></a>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:if test="count(commands/remove-request) &gt; 0">
            <a class="btn btn-mini" href="{commands/remove-request}">
              <i class="icon-remove-circle"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
              <xsl:value-of select="commands/remove-request/@caption" /></a>
          </xsl:if>
        </p>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>