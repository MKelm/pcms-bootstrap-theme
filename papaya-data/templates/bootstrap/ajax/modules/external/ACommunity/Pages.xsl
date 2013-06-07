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

  <!-- get image thumbnail link output on request -->
  <xsl:template match="a[img/@class = 'papayaImage']">
    <a>
      <xsl:copy-of select="@*" />
      <img class="thumbnail pull-left" alt="{img/@alt}" src="{img/@src}" />
    </a>
  </xsl:template>

</xsl:stylesheet>