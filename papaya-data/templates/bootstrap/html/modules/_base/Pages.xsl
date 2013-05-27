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
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-topic">
    <xsl:param name="pageContent"/>
    <xsl:param name="withText" select="true()"/>
    <xsl:param name="withHook" select="false()" />

    <div class="hero-unit">
      <xsl:choose>
        <xsl:when test="$pageContent/image[@align='left']//img">
          <img class="hero-image thumbnail pull-left">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
        <xsl:when test="$pageContent/image[@align='right']//img">
          <img class="hero-image thumbnail pull-right">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
      </xsl:choose>

      <h1>
        <xsl:if test="$withHook">
          <xsl:attribute name="class">pull-left</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$pageContent/title/text()"/>
        <xsl:if test="$pageContent/subtitle/text() != ''">
          <xsl:text> </xsl:text>
          <small><xsl:value-of select="$pageContent/subtitle"/></small>
        </xsl:if>
      </h1>

      <xsl:if test="$withHook">
        <xsl:call-template name="inner-content-hook">
          <xsl:with-param name="additionalCssClass" select="'pull-right'" />
        </xsl:call-template>
        <xsl:call-template name="float-fix" />
      </xsl:if>

      <xsl:if test="$withText">
        <xsl:apply-templates select="$pageContent/text/*|$pageContent/text/text()" />
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>