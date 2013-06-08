<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../../html/base/dialogs.xsl"/>
  <xsl:import href="../../../../html/modules/external/ACommunity/Ui/Content/Comments.xsl"/>

  <xsl:template match="acommunity-comments">
    <xsl:call-template name="acommunity-comments">
      <xsl:with-param name="commandName" select="command/@name" />
      <xsl:with-param name="commandCommentId" select="command/@comment_id" />
      <xsl:with-param name="comments" select="comments" />
      <xsl:with-param name="dialog" select="dialog-box" />
      <xsl:with-param name="dialogMessage" select="dialog-message" />
    </xsl:call-template>
  </xsl:template>

  <!-- get thumbnail link output on request -->
  <xsl:template match="a[img/@class = 'papayaImage']">
    <xsl:call-template name="extended-text-thumbnails-thumbnail" />
  </xsl:template>

  <!-- get video link output on request -->
  <xsl:template match="video-link">
    <xsl:call-template name="extended-text-videos-video">
      <xsl:with-param name="previewImageOnly" select="true()" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>