<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
  @papaya:modules actionbox_sitemap
-->

<xsl:import href="./base/boxes.xsl" />

<xsl:template match="sitemap">
  <xsl:call-template name="navigation" />
</xsl:template>

</xsl:stylesheet>
