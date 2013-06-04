<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
    @papaya:modules content_imgtopic
  -->

  <!-- default templates to use and maybe overload -->
  <xsl:import href="../html/base/base.xsl" />

  <!--
    template set parameters for page_main
  -->

  <!-- load current language texts -->
  <xsl:param name="LANGUAGE_TEXTS_CURRENT" select="document(concat('../html/', $PAGE_LANGUAGE, '.xml'))" />
  <!-- load fallback language texts -->
  <xsl:param name="LANGUAGE_TEXTS_FALLBACK" select="document('../html/en-US.xml')" />

  <!-- call the page template for the root tag -->
  <xsl:template match="/page">
    <requested-content>
      <xsl:apply-templates select="content/topic/*" />
    </requested-content>
  </xsl:template>

</xsl:stylesheet>