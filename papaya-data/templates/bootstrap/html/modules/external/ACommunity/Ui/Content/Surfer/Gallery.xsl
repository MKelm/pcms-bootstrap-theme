<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../../../../../_functions/javascript-escape-string.xsl" />

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat('../../../', $PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('../../../en-US.xml')"/>

  <xsl:template name="page-styles">
  </xsl:template>

  <xsl:template name="module-content-image-gallery">
    <xsl:param name="pageContent"/>
    <xsl:call-template name="module-content-topic">
      <xsl:with-param name="pageContent" select="$pageContent" />
      <xsl:with-param name="withText" select="not($pageContent/image)" />
    </xsl:call-template>
    <div class="gallery">

      <xsl:if test="count($pageContent/images/image) &gt; 0 or count($pageContent/image) &gt; 0">
        <xsl:call-template name="module-content-gallery-navigation">
          <xsl:with-param name="navigation" select="$pageContent/navigation" />
        </xsl:call-template>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$pageContent/images/image">

          <xsl:variable name="rows" select="ceiling(count($pageContent/images/image)
            div $pageContent/options/max_per_line)" />
          <xsl:call-template name="module-content-gallery-image-rows">
            <xsl:with-param name="images" select="$pageContent/images/image" />
            <xsl:with-param name="rows" select="$rows" />
            <xsl:with-param name="fieldsPerRow" select="$pageContent/options/max_per_line" />
          </xsl:call-template>

        </xsl:when>
        <xsl:when test="$pageContent/image">
          <xsl:call-template name="module-content-gallery-images">
            <xsl:with-param name="isSingleImage" select="true()" />
            <xsl:with-param name="images" select="$pageContent/image" />
            <xsl:with-param name="navigation" select="$pageContent/navigation" />
            <xsl:with-param name="allowTitle" select="true()" />
            <xsl:with-param name="allowDescription" select="true()" />
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="float-fix"/>
      <xsl:choose>
        <xsl:when test="count($pageContent/images/image) &gt; 0 or count($pageContent/image) &gt; 0">
          <xsl:call-template name="module-content-gallery-navigation">
            <xsl:with-param name="navigation" select="$pageContent/navigation" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="alert">
            <xsl:with-param name="type" select="'error'" />
            <xsl:with-param name="message">
              <xsl:call-template name="language-text">
                <xsl:with-param name="text" select="'GALLERY_NO_IMAGES'"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>


  <xsl:template name="module-content-gallery-image-rows">
    <xsl:param name="images" />
    <xsl:param name="rows" />
    <xsl:param name="row" select="'1'" />
    <xsl:param name="fieldsPerRow" />
    <xsl:param name="position" select="'1'" />

    <xsl:if test="$position = 1 or ($position mod $fieldsPerRow = 1)">
      <div class="row-fluid">
        <xsl:call-template name="module-content-gallery-images">
          <xsl:with-param name="images" select="$images" />
          <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
          <xsl:with-param name="position" select="$position" />
          <xsl:with-param name="row" select="$row" />
        </xsl:call-template>
      </div>
    </xsl:if>

    <xsl:if test="$row &lt; $rows">
      <xsl:call-template name="module-content-gallery-image-rows">
        <xsl:with-param name="images" select="$images" />
        <xsl:with-param name="rows" select="$rows" />
        <xsl:with-param name="row" select="$row + 1" />
        <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
        <xsl:with-param name="position" select="$position + $fieldsPerRow" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-gallery-images">
    <xsl:param name="isSingleImage" select="false()" />
    <xsl:param name="images" select="false()" />
    <xsl:param name="navigation" select="false()" />
    <xsl:param name="fieldsPerRow" select="'0'" />
    <xsl:param name="position" select="'1'" />
    <xsl:param name="allowTitle" select="false()" />
    <xsl:param name="allowDescription" select="false()" />
    <xsl:param name="row" select="false()" />

    <xsl:if test="$images">
      <xsl:variable name="currentImage" select="$images[position() = $position]" />

      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$fieldsPerRow = 3">span4</xsl:when>
            <xsl:when test="$fieldsPerRow = 2">span6</xsl:when>
            <xsl:when test="$fieldsPerRow = 1">span12</xsl:when>
            <xsl:when test="$fieldsPerRow = 0">single-image</xsl:when>
          </xsl:choose>
        </xsl:attribute>

        <xsl:choose>
          <xsl:when test="$navigation != false() and $navigation/navlink[@direction = 'index']">
            <a href="{$navigation/navlink[@direction = 'index']/@href}">
              <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}"/>
            </a>
          </xsl:when>
          <xsl:when test="$currentImage/destination and $currentImage/destination/@href">
            <a href="{$currentImage/destination/@href}" title="{$currentImage/title}">
              <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$allowTitle != false() and $currentImage/title">
          <h2><xsl:value-of select="$currentImage/title"/></h2>
        </xsl:if>
        <xsl:if test="$allowDescription and $currentImage/description">
          <div class="description">
            <xsl:apply-templates select="$currentImage/description"/>
          </div>
        </xsl:if>
        <xsl:if test="$currentImage/original-link">
          <div class="original-image"><a href="{$currentImage/original-link}">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text" select="'GALLERY_ORIGINAL_IMAGE'"/>
            </xsl:call-template></a>
          </div>
        </xsl:if>
        <xsl:if test="$currentImage/download-link">
          <div class="image-download"><a href="{$currentImage/download-link}">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text" select="'GALLERY_IMAGE_DOWNLOAD'"/>
            </xsl:call-template></a>
          </div>
        </xsl:if>
      </div>

      <xsl:if test="not($isSingleImage) and $position div $fieldsPerRow &lt; $row">
        <xsl:call-template name="module-content-gallery-images">
          <xsl:with-param name="images" select="$images" />
          <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
          <xsl:with-param name="position" select="$position + 1" />
          <xsl:with-param name="row" select="$row" />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-gallery-navigation">
    <xsl:param name="navigation" />
    <xsl:if test="$navigation/navlink[(@direction = 'previous') or (@direction = 'next')]">
      <div class="pagination">
        <ul>
          <xsl:if test="$navigation/navlink[@direction = 'previous']">
            <li><a href="{$navigation/navlink[@direction = 'previous']/@href}">&#171;</a></li>
          </xsl:if>
          <xsl:if test="$navigation/navlink[@direction = 'index']">
            <li><a href="{$navigation/navlink[@direction = 'index']/@href}">
              <xsl:call-template name="language-text">
                <xsl:with-param name="text" select="'GALLERY_INDEX'"/>
              </xsl:call-template></a></li>
          </xsl:if>
          <xsl:if test="$navigation/navlink[@direction = 'next']">
            <li><a href="{$navigation/navlink[@direction = 'next']/@href}">&#187;</a></li>
          </xsl:if>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>