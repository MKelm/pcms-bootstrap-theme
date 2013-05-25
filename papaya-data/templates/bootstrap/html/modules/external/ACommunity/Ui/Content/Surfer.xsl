<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="module-content-acommunity-surfer-page">
    <xsl:param name="pageContent" />

    <xsl:choose>
      <xsl:when test="count($pageContent/details/group) &gt; 0">
        <div class="hero-unit surfer">
          <xsl:call-template name="module-content-acommunity-surfer-page-base-details">
            <xsl:with-param name="baseDetails" select="$pageContent/details/group[@id = 0]" />
            <xsl:with-param name="pageContent" select="$pageContent" />
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="alert">
          <xsl:with-param name="type" select="'error'" />
          <xsl:with-param name="message" select="$pageContent/message[@type = 'no-surfer']" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="module-content-acommunity-surfer-page-base-details">
    <xsl:param name="baseDetails" />
    <xsl:param name="pageContent" />

    <img src="{$baseDetails/detail[@name = 'avatar']/text()}" alt="{$baseDetails/detail[@name = 'avatar']/@caption}" class="hero-image thumbnail pull-left" />

    <h1><xsl:value-of select="$baseDetails/detail[@name = 'name']" /></h1>

    <div class="surfer-details">
      <ul class="inline">
        <li><xsl:value-of select="$baseDetails/detail[@name = 'gender']/@caption" />: <xsl:value-of select="$baseDetails/detail[@name = 'gender']" /></li>
        <li><xsl:value-of select="$baseDetails/detail[@name = 'group']/@caption" />: <xsl:value-of select="$baseDetails/detail[@name = 'group']" /></li>
      </ul>

      <ul class="unstyled">
        <li><xsl:value-of select="$baseDetails/detail[@name = 'lastlogin']/@caption" />:<xsl:text> </xsl:text>
        <xsl:call-template name="format-date-time">
          <xsl:with-param name="dateTime" select="$baseDetails/detail[@name = 'lastlogin']" />
        </xsl:call-template>
        </li>
        <li><xsl:value-of select="$baseDetails/detail[@name = 'lastaction']/@caption" />:<xsl:text> </xsl:text>
        <xsl:call-template name="format-date-time">
          <xsl:with-param name="dateTime" select="$baseDetails/detail[@name = 'lastaction']" />
        </xsl:call-template>
        </li>
        <li><xsl:value-of select="$baseDetails/detail[@name = 'registration']/@caption" />:<xsl:text> </xsl:text>
        <xsl:call-template name="format-date-time">
          <xsl:with-param name="dateTime" select="$baseDetails/detail[@name = 'registration']" />
        </xsl:call-template>
        </li>
      </ul>

      <ul class="inline">
        <xsl:call-template name="module-content-acommunity-surfer-page-contact">
          <xsl:with-param name="pageContent" select="$pageContent" />
        </xsl:call-template>
        <xsl:if test="$pageContent/send-message-link">
          <li><a class="surferSendMessageLink" href="{$pageContent/send-message-link}"><xsl:value-of select="$pageContent/send-message-link/@caption" /></a></li>
        </xsl:if>
        <li><a href="mailto:{$baseDetails/detail[@name = 'email']}"><xsl:value-of select="$baseDetails/detail[@name = 'email']/@caption" /></a></li>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="module-content-acommunity-surfer-page-contact">
    <xsl:param name="pageContent" />

    <xsl:if test="$pageContent/contact">
      <xsl:variable name="contact" select="$pageContent/contact" />
      <xsl:choose>
        <xsl:when test="$contact/@status = 'none' or $contact/@status = 'own_pending' or $contact/@status = 'direct'">
          <li><a href="{$contact/command}" title="{$contact/command/@caption}" ><xsl:value-of select="$contact/@status-caption" /></a></li>
        </xsl:when>
        <xsl:when test="$contact/@status = 'pending'">
          <li><xsl:value-of select="$contact/@status-caption" />
          <xsl:for-each select="$contact/command">
            <xsl:text> </xsl:text><a href="{.}"><xsl:value-of select="@caption" /></a>
          </xsl:for-each>
          </li>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-acommunity-surfer-page-after-content-hook-before">
    <xsl:param name="pageContent" />

    <xsl:if test="count($pageContent/details/group[@id != 0]) &gt; 0">
      <div class="surfer-details-dynamic">
        <xsl:variable name="rows" select="ceiling(count($pageContent/details/group[@id != 0]) div 2)" />
        <xsl:variable name="fieldsPerRow" select="'2'" />

        <xsl:call-template name="module-content-acommunity-surfer-page-detail-groups">
          <xsl:with-param name="groups" select="$pageContent/details/group[@id != 0]" />
          <xsl:with-param name="rows" select="$rows" />
          <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
        </xsl:call-template>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-acommunity-surfer-page-detail-groups">
    <xsl:param name="groups" />
    <xsl:param name="rows" />
    <xsl:param name="fieldsPerRow" />
    <xsl:param name="position" select="'1'" />

    <xsl:choose>
      <xsl:when test="$position = 1 or ($position - 1 mod $fieldsPerRow = 0)">
        <div class="row-fluid">
          <xsl:call-template name="module-content-acommunity-surfer-page-details">
            <xsl:with-param name="details" select="$groups[position() = $position]" />
            <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
          </xsl:call-template>
          <xsl:if test="$position &lt; $rows * $fieldsPerRow">
            <xsl:call-template name="module-content-acommunity-surfer-page-detail-groups">
              <xsl:with-param name="groups" select="$groups" />
              <xsl:with-param name="rows" select="$rows" />
              <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
              <xsl:with-param name="position" select="$position + 1" />
            </xsl:call-template>
          </xsl:if>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="module-content-acommunity-surfer-page-details">
          <xsl:with-param name="details" select="$groups[position() = $position]" />
          <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
        </xsl:call-template>
        <xsl:if test="$position &lt; $rows * $fieldsPerRow">
          <xsl:call-template name="module-content-acommunity-surfer-page-detail-groups">
            <xsl:with-param name="groups" select="$groups" />
            <xsl:with-param name="rows" select="$rows" />
            <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
            <xsl:with-param name="position" select="$position + 1" />
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="module-content-acommunity-surfer-page-details">
    <xsl:param name="details" />
    <xsl:param name="fieldsPerRow" />

    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$fieldsPerRow = 1">span12</xsl:when>
          <xsl:when test="$fieldsPerRow = 2">span6</xsl:when>
          <xsl:when test="$fieldsPerRow = 3">span4</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <h2><xsl:value-of select="$details/@caption" /></h2>
      <ul class="unstyled">
        <xsl:for-each select="$details/detail">
          <li><xsl:value-of select="@caption" />: <xsl:value-of select="." /></li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>