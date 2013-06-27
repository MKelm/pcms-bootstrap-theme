<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="Paging.xsl"/>
  <xsl:import href="Extended/Text.xsl"/>

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat('../../', $PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('../../en-US.xml')"/>

  <xsl:template name="acommunity-comments-dialog">
    <xsl:param name="dialog" />
    <xsl:param name="dialogMessage" />
    <xsl:param name="parentAnchor" />

    <xsl:call-template name="dialog">
      <xsl:with-param name="dialog" select="$dialog" />
      <xsl:with-param name="message" select="$dialogMessage" />
      <xsl:with-param name="inputSize" select="'xxlarge'" />
      <xsl:with-param name="parentAnchor" select="$parentAnchor" />
    </xsl:call-template>
    <xsl:call-template name="extended-text-dialog-thumbnails-container">
      <xsl:with-param name="type" select="'comment'" />
    </xsl:call-template>
    <xsl:call-template name="extended-text-dialog-videos-container">
      <xsl:with-param name="type" select="'comment'" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="acommunity-comments">
    <xsl:param name="commandName" select="'reply'" />
    <xsl:param name="commandCommentId" select="0" />
    <xsl:param name="commentId" select="0" />
    <xsl:param name="comments" />
    <xsl:param name="dialog" />
    <xsl:param name="dialogMessage" />
    <xsl:param name="indent" select="false()" />
    <xsl:param name="parentAnchor" select="''" />
    <xsl:param name="mode" select="'list'" />
    <xsl:param name="maxTextLength" select="'0'" />

    <xsl:choose>
      <xsl:when test="$commentId = 0 and $commandName = 'reply' and $commandCommentId = $commentId">
        <xsl:call-template name="acommunity-comments-dialog">
          <xsl:with-param name="dialog" select="$dialog" />
          <xsl:with-param name="dialogMessage" select="$dialogMessage" />
          <xsl:with-param name="parentAnchor" select="$parentAnchor" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="count($comments/comment) = 0 and $commentId &gt; 0 and $commandCommentId = $commentId">
        <div class="media comment">
          <xsl:call-template name="acommunity-comments-dialog">
          <xsl:with-param name="dialog" select="$dialog" />
          <xsl:with-param name="dialogMessage" select="$dialogMessage" />
          <xsl:with-param name="parentAnchor" select="$parentAnchor" />
        </xsl:call-template>
        </div>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="count($comments/comment) &gt; 0">
      <xsl:for-each select="$comments/comment">
        <div class="media comment">
          <xsl:if test="position() = 1 and $commentId &gt; 0 and $commandName = 'reply' and $commandCommentId = $commentId">
            <xsl:call-template name="acommunity-comments-dialog">
              <xsl:with-param name="dialog" select="$dialog" />
              <xsl:with-param name="dialogMessage" select="$dialogMessage" />
              <xsl:with-param name="parentAnchor" select="$parentAnchor" />
            </xsl:call-template>
          </xsl:if>

          <xsl:variable name="anchor">
            <xsl:text>comment_</xsl:text><xsl:value-of select="@id" />
          </xsl:variable>
          <xsl:variable name="previousAnchor">
            <xsl:if test="position() &gt; 1">
              <xsl:text>comment_</xsl:text><xsl:value-of select="preceding-sibling::comment/@id" />
            </xsl:if>
          </xsl:variable>
          <a name="{$anchor}"><xsl:text> </xsl:text></a>
          <a href="{surfer/@page-link}" class="pull-left"><img class="media-object" src="{surfer/@avatar}" alt="" /></a>
          <div class="media-body">
            <h4 class="media-heading"><a href="{surfer/@page-link}"><xsl:value-of select="surfer/@name" /></a>
            <xsl:text> </xsl:text><small class="pull-right"><xsl:call-template name="format-date">
                    <xsl:with-param name="date" select="@time" />
                  </xsl:call-template><xsl:text>, </xsl:text>
                  <xsl:call-template name="format-time">
                    <xsl:with-param name="time" select="substring(@time, 12, 8)" />
                  </xsl:call-template></small></h4>
            <p>
              <xsl:choose>
                <xsl:when test="$maxTextLength &gt; 0 and string-length(text-raw/text()) &gt; $maxTextLength">
                  <xsl:value-of select="substring(text-raw/text(), 1, $maxTextLength - 3)" /><xsl:text>...</xsl:text>
                </xsl:when>
                <xsl:otherwise><xsl:copy-of select="text/node()" /></xsl:otherwise>
              </xsl:choose>
            </p>
            <xsl:if test="$mode = 'list'">
              <xsl:call-template name="extended-text-thumbnails" />
              <xsl:call-template name="extended-text-videos" />
            </xsl:if>
            <xsl:if test="$mode = 'list' or $mode = 'ajax-list'">
              <xsl:call-template name="acommunity-comments-comment-extras">
                <xsl:with-param name="commandLinks" select="command-links/link" />
                <xsl:with-param name="anchor" select="$anchor" />
                <xsl:with-param name="previousAnchor" select="$previousAnchor" />
              </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="float-fix" />
            <xsl:call-template name="acommunity-comments">
              <xsl:with-param name="commandName" select="$commandName" />
              <xsl:with-param name="commandCommentId" select="$commandCommentId" />
              <xsl:with-param name="commentId" select="@id" />
              <xsl:with-param name="comments" select="comments" />
              <xsl:with-param name="dialog" select="$dialog" />
              <xsl:with-param name="dialogMessage" select="$dialogMessage" />
              <xsl:with-param name="indent" select="true()" />
              <xsl:with-param name="parentAnchor" select="$anchor" />
              <xsl:with-param name="mode" select="$mode" />
              <xsl:with-param name="maxTextLength" select="$maxTextLength" />
            </xsl:call-template>
          </div>
        </div>
      </xsl:for-each>

      <xsl:call-template name="acommunity-content-paging">
        <xsl:with-param name="paging" select="$comments/paging" />
        <xsl:with-param name="parentAnchor" select="$parentAnchor" />
      </xsl:call-template>
      <xsl:call-template name="float-fix" />

    </xsl:if>
  </xsl:template>

  <xsl:template name="acommunity-comments-comment-extras">
    <xsl:param name="commandLinks" />
    <xsl:param name="anchor" />
    <xsl:param name="previousAnchor" />

    <ul class="voting inline pull-left">
      <li>
        <div class="btn-toolbar">
          <div class="btn-group">
            <xsl:variable name="buttonClass">
              <xsl:choose>
                <xsl:when test="$commandLinks[@name = 'vote_up'] and $commandLinks[@name = 'vote_down']">
                  <xsl:text>btn btn-mini</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>btn btn-mini disabled</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <a class="{$buttonClass}">
              <xsl:if test="$commandLinks[@name = 'vote_up']">
                <xsl:attribute name="title">
                  <xsl:value-of select="$commandLinks[@name = 'vote_up']/@caption" />
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="$commandLinks[@name = 'vote_up']" /><xsl:text>#</xsl:text>
                  <xsl:value-of select="$anchor" />
                </xsl:attribute>
              </xsl:if><i class="icon-plus"><xsl:text> </xsl:text></i></a>
            <a class="{$buttonClass}">
              <xsl:if test="$commandLinks[@name = 'vote_down']">
                <xsl:attribute name="title">
                  <xsl:value-of select="$commandLinks[@name = 'vote_down']/@caption" />
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="$commandLinks[@name = 'vote_down']" /><xsl:text>#</xsl:text>
                  <xsl:value-of select="$anchor" />
                </xsl:attribute>
              </xsl:if><i class="icon-minus"><xsl:text> </xsl:text></i></a>
          </div>
        </div>
      </li>
      <li>
        <small class="votes-score"><xsl:value-of select="@votes_score" />
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="@votes_score = 1 or @votes_score = -1">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">VOTES_SCORE_POINT</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">VOTES_SCORE_POINTS</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose></small>
      </li>
    </ul>
    <ul class="inline pull-right">
      <xsl:if test="$commandLinks[@name = 'delete']">
        <li><a class="btn btn-mini" href="{$commandLinks[@name = 'delete']}#{$previousAnchor}">
          <i class="icon-remove"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
          <xsl:value-of select="$commandLinks[@name = 'delete']/@caption" /></a></li>
      </xsl:if>
      <xsl:if test="$commandLinks[@name = 'reply']">
        <li><a class="btn btn-mini" href="{$commandLinks[@name = 'reply']}#{$anchor}">
          <i class="icon-pencil"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
          <xsl:value-of select="$commandLinks[@name = 'reply']/@caption" /></a></li>
      </xsl:if>
    </ul>
  </xsl:template>

</xsl:stylesheet>