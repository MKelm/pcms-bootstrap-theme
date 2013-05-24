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

    <div class="hero-unit">

      <xsl:choose>
        <xsl:when test="$pageContent/image[@align='left']//img">
          <img class="heroImage thumbnail pull-left">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
        <xsl:when test="$pageContent/image[@align='right']//img">
          <img class="heroImage thumbnail pull-right">
            <xsl:copy-of select="$pageContent/image//img/@*[local-name() != 'class']" />
          </img>
        </xsl:when>
      </xsl:choose>

      <h1>
        <xsl:value-of select="$pageContent/title/text()"/>
        <xsl:if test="$pageContent/subtitle/text() != ''">
          <xsl:text> </xsl:text>
          <span class="subTitle"><xsl:value-of select="$pageContent/subtitle"/></span>
        </xsl:if>
      </h1>

      <xsl:if test="$withText">
        <xsl:apply-templates select="$pageContent/text/*|$pageContent/text/text()" />
      </xsl:if>
    </div>

    <xsl:call-template name="papaya-error" />
    <xsl:call-template name="papaya-redirect" />

  </xsl:template>

</xsl:stylesheet>