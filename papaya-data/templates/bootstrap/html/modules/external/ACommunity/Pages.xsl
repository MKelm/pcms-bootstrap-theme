<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="./Ui/Content/Paging.xsl"/>
  <xsl:import href="./Ui/Content/Surfer.xsl"/>
  <xsl:import href="./Ui/Content/Surfer/Editor.xsl"/>
  <xsl:import href="./Ui/Content/Surfer/Gallery.xsl"/>

  <xsl:template name="page-styles">
  </xsl:template>

  <xsl:template name="after-content-hook-before">
    <xsl:param name="pageContent" />

    <xsl:choose>
      <xsl:when test="$pageContent/@module = 'ACommunitySurferPage'">
        <xsl:call-template name="module-content-acommunity-surfer-page-after-content-hook-before">
          <xsl:with-param name="pageContent" select="$pageContent/surfer-page"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/@module = 'ACommunityMessagesPage'">
        <xsl:call-template name="module-content-acommunity-messages-page-after-content-hook-before">
          <xsl:with-param name="pageContent" select="$pageContent/acommunity-messages"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="content-area">
    <xsl:param name="pageContent"/>

    <xsl:choose>
      <xsl:when test="$pageContent/@module = 'ACommunitySurferPage'">
        <xsl:call-template name="module-content-acommunity-surfer-page">
          <xsl:with-param name="pageContent" select="$pageContent/surfer-page"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/@module = 'ACommunitySurferEditorPage'">
        <xsl:call-template name="module-content-community-profile">
          <xsl:with-param name="pageContent" select="$pageContent"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/@module = 'ACommunitySurferGalleryPage'">
        <xsl:call-template name="module-content-image-gallery">
          <xsl:with-param name="pageContent" select="$pageContent"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/@module = 'ACommunityMessagesPage'">
        <xsl:call-template name="module-content-acommunity-messages-page">
          <xsl:with-param name="pageContent" select="$pageContent/acommunity-messages"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="module-content-acommunity-messages-page">
    <xsl:param name="pageContent" />

    <xsl:call-template name="module-content-topic">
      <xsl:with-param name="pageContent" select="$pageContent" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="module-content-acommunity-messages-page-after-content-hook-before">
    <xsl:param name="pageContent" />

    <xsl:call-template name="dialog">
      <xsl:with-param name="dialog" select="$pageContent/dialog-box" />
      <xsl:with-param name="message" select="$pageContent/dialog-message" />
      <xsl:with-param name="class" select="'message-dialog'" />
      <xsl:with-param name="inputSize" select="'xxlarge'" />
    </xsl:call-template>

    <xsl:if test="$pageContent/message">
      <xsl:call-template name="alert">
        <xsl:with-param name="message" select="$pageContent/message" />
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="$pageContent/messages/message">
      <div class="media message">
        <a class="pull-left" href="{surfer/@page-link}"><img class="media-object" alt="" src="{surfer/@avatar}" /></a>
        <div class="media-body">
          <h4 class="media-heading"><a href="{surfer/@page-link}"><xsl:value-of select="surfer/@name" /></a>
            <xsl:text> </xsl:text>
            <small><xsl:call-template name="format-date">
                  <xsl:with-param name="date" select="@time" />
                </xsl:call-template><xsl:text>, </xsl:text>
                <xsl:call-template name="format-time">
                  <xsl:with-param name="time" select="substring(@time, 12, 8)" />
                </xsl:call-template></small>
          </h4>
          <p><xsl:copy-of select="text/node()" /><xsl:text> </xsl:text></p>
          <xsl:if test="text-thumbnail-links">
            <p class="thumbnails">
              <xsl:for-each select="text-thumbnail-links/a">
                <a>
                  <xsl:copy-of select="@*" />
                  <img class="thumbnail pull-left" src="{img/@src}" alt="" />
                </a>
              </xsl:for-each>
            </p>
            <xsl:call-template name="float-fix" />
          </xsl:if>
        </div>
      </div>
    </xsl:for-each>
    <xsl:call-template name="acommunity-content-paging">
      <xsl:with-param name="paging" select="$pageContent/messages/paging" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>