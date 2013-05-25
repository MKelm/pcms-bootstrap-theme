<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  @papaya:modules actionbox_sitemap
-->

<xsl:import href="./base/boxes.xsl" />

<xsl:template match="sitemap">
  <xsl:call-template name="navigation">
    <xsl:with-param name="sidebar" select="true()" />
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
