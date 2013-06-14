<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
    @papaya:modules content_imgtopic, content_categimg
  -->

  <!-- default templates to use and maybe overload -->
  <xsl:import href="./base/defaults.xsl" />
  <xsl:import href="./modules/_base/Pages.xsl" />

  <xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />

  <!--
    template set parameters for page_main
  -->

  <!-- load file containing module specific css/js files name definitions -->
  <xsl:param name="BOX_MODULE_FILES" select="document('boxes.xml')" />
  <!-- load current language texts -->
  <xsl:param name="LANGUAGE_TEXTS_CURRENT" select="document(concat($PAGE_LANGUAGE, '.xml'))" />
  <!-- load fallback language texts -->
  <xsl:param name="LANGUAGE_TEXTS_FALLBACK" select="document('en-US.xml')" />

  <!-- call the page template for the root tag -->
  <xsl:template match="/page">
    <xsl:call-template name="page" />
  </xsl:template>

</xsl:stylesheet>