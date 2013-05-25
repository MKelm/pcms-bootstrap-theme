<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="./Ui/Content/Surfer.xsl"/>
  <xsl:import href="./Ui/Content/Surfer/Editor.xsl"/>

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
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
