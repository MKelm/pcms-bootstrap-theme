<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="Paging.xsl"/>

  <xsl:template name="module-content-acommunity-groups-page">
    <xsl:param name="pageContent" />

    <xsl:call-template name="alert">
      <xsl:with-param name="message" select="$pageContent/message" />
    </xsl:call-template>

    <xsl:if test="$pageContent/commands/add">
      <ul class="nav nav-tabs">
        <li>
          <xsl:if test="$pageContent/commands/add/@active = '1'">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:if>
          <a href="{$pageContent/commands/add}"><xsl:value-of select="$pageContent/commands/add/@caption" /></a>
        </li>
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
        <h4 class="media-heading"><a href="{@page-link}"><xsl:value-of select="@title" /></a></h4>
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
        </p>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>