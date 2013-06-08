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
    <p class="{$type}-form-videos" data-preloader-image="{$PAGE_THEME_PATH}img/thumbnail_link_preloader.gif">
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
    <xsl:param name="previewImageOnly" select="false()" />
    <xsl:variable name="hosterTitle">
      <xsl:choose>
        <xsl:when test="@hoster = 'vimeo'">Vimeo</xsl:when>
        <xsl:when test="@hoster = 'youtube'">Youtube</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$previewImageOnly = true()">
        <div class="video-preview-image">
        <a href="{@src}" title="{@title}"><img class="thumbnail" alt="{img/@alt}" src="{img/@src}"
          style="width: {@width}px; height: {@height}px;" /></a>
        <div class="video-preview-image-overlay-title">
          <a href="{@src}" title="{@title}"><h2><xsl:value-of select="$hosterTitle" />:
          <xsl:value-of select="substring(@title, 1, 25)" />...</h2></a>
        </div>
        <div class="video-preview-image-overlay-play">
          <a href="{@src}" title="{@title}"><i class="video-play-button"><xsl:text> </xsl:text></i></a></div>
        </div>
      </xsl:when>
      <xsl:otherwise>
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
        <script><xsl:comment>
          var title = '<xsl:value-of select="@title-js-escaped" />',
          onClick = 'extendedText.replaceVideoPreviewImage(this); return false;';
          document.write(
            '&lt;div class="video-preview-image"&gt;'+
            '&lt;a onclick="'+onClick+'" href="<xsl:value-of select="@src" />" title="'+title+'"&gt;' +
            '&lt;img class="thumbnail" alt="<xsl:value-of select="img/@alt" />" '+
            'src="<xsl:value-of select="img/@src" />" style="width: <xsl:value-of select="@width" />px; '+
            'height: <xsl:value-of select="@height" />px;" /&gt;&lt;/a&gt;'+
            '&lt;div class="video-preview-image-overlay-title"&gt;'+
            '&lt;a onclick="'+onClick+'" href="<xsl:value-of select="@src" />" title="'+title+'"&gt;'+
            '&lt;h2&gt;<xsl:value-of select="$hosterTitle" />: '+
            '<xsl:value-of select="substring(@title, 1, 25)" />...&lt;/h2&gt;&lt;/a&gt;'+
            '&lt;/div&gt;'+
            '&lt;div class="video-preview-image-overlay-play"&gt;'+
            '&lt;a onclick="'+onClick+'" href="<xsl:value-of select="@src" />" title="'+title+'"&gt;'+
            '&lt;i class="video-play-button"&gt; &lt;/i&gt;&lt;/a&gt;&lt;/div&gt;'+
            '&lt;/div&gt;'
          );
        </xsl:comment></script>
        <noscript>
          <iframe class="thumbnail" width="{@width}" height="{@height}" src="{$embedUrl}" frameborder="0"
            webkitAllowFullScreen="webkitAllowFullScreen" mozallowfullscreen="mozallowfullscreen"
            allowFullScreen="allowFullScreen"><xsl:text> </xsl:text></iframe>
        </noscript>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>