<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="extended-text-dialog-thumbnails-container">
    <xsl:param name="type" />
    <p class="{$type}-form-thumbnails" data-preloader-image="{$PAGE_THEME_PATH}img/thumbnail_link_preloader.gif">
      <xsl:text> </xsl:text></p> <!-- container for thumbnail links by javascript -->
    <xsl:call-template name="float-fix" />
  </xsl:template>

  <xsl:template name="extended-text-dialog-videos-container">
    <xsl:param name="type" />
    <p class="{$type}-form-videos" data-preloader-image="">
      <xsl:text> </xsl:text></p> <!-- container for video links by javascript -->
  </xsl:template>

  <xsl:template name="extended-text-thumbnails">
    <xsl:if test="text-thumbnail-links">
      <p class="thumbnails">
        <xsl:for-each select="text-thumbnail-links/a">
          <xsl:call-template name="extended-text-thumbnails-thumbnail" />
        </xsl:for-each>
      </p>
      <xsl:call-template name="float-fix" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="extended-text-thumbnails-thumbnail">
    <a>
      <xsl:copy-of select="@*" />
      <img class="thumbnail pull-left" src="{img/@src}" alt="{img/@alt}" />
    </a>
  </xsl:template>

  <xsl:template name="extended-text-videos">
    <xsl:if test="text-video-links">
      <p class="videos">
        <!-- embed first video only, remove the position selector to get all videos as iframe -->
        <xsl:for-each select="text-video-links/video-link[position() = 1]">
          <xsl:call-template name="extended-text-videos-video" />
        </xsl:for-each>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template name="extended-text-videos-video">
    <xsl:variable name="embedUrl">
      <xsl:choose>
        <xsl:when test="@hoster = 'vimeo'">
          <xsl:text>http://player.vimeo.com/video/</xsl:text>
          <xsl:value-of select="@id" />
          <xsl:text>?title=0&amp;byline=0&amp;portrait=0&amp;badge=0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>http://www.youtube.com/embed/</xsl:text>
          <xsl:value-of select="@id" />
          <xsl:text>?feature=player_detailpage</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <iframe width="{@width}" height="{@height}" src="{$embedUrl}" frameborder="0"
      webkitAllowFullScreen="webkitAllowFullScreen" mozallowfullscreen="mozallowfullscreen"
      allowFullScreen="allowFullScreen"><xsl:text> </xsl:text></iframe>
  </xsl:template>

</xsl:stylesheet>