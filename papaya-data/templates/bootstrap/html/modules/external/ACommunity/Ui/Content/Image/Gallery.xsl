<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../../../../../_functions/javascript-escape-string.xsl" />

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat('../../../', $PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('../../../en-US.xml')"/>

  <xsl:template name="module-content-image-gallery-page-styles">
    <xsl:if test="/page/content/topic[@module = 'ACommunityImageGalleryPage']/options/lightbox = '1' and
        count(/page/content/topic/images/image) &gt; 1">
      <xsl:call-template name="link-style">
        <xsl:with-param name="files">
          <file>fancybox/jquery.fancybox.css</file>
          <file>fancybox/helpers/jquery.fancybox-extras.css</file>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-image-gallery-page-scripts-lazy">
    <xsl:if test="count(/page/content/topic/images/image) &gt; 1">
      <script><xsl:comment>
        jQuery(document).ready( function() {
          var images = [
            <xsl:for-each select="/page/content/topic/images/image">
              <xsl:if test="position() &gt; 1">,</xsl:if>
              ['<xsl:value-of select="destination/img/@src" />',
              '<xsl:value-of select="img/@src" />',
              '<xsl:value-of select="title" />',
              '<xsl:value-of select="following::*[position() &lt; 3 and name() = 'image-description']" />',
              '<xsl:value-of select="img/@alt" />']
            </xsl:for-each>
          ];
          $('div[data-image-position]').each(function (index) {
            var image = images[index];
            $(this).html(
              '&lt;a class="image-thumbnail-link" data-fancybox-group="gallery" ' +
              'data-fancybox-description="' + image[3] + '" ' +
              'href="' + image[0] + '" title="' + image[2] + '"&gt;' +
              '&lt;img class="thumbnail" src="<xsl:value-of select="$PAGE_THEME_PATH" />' +
              'img/image_unveil_placeholder_<xsl:value-of select="$PAGE_LANGUAGE" />.png" ' +
              'data-src="' + image[1] + '" alt="' + image[4] + '"/&gt;&lt;/a&gt;'
            );
          });
        });
      </xsl:comment></script>
      <xsl:choose>
        <xsl:when test="/page/content/topic[@module = 'ACommunityImageGalleryPage']/options/lightbox = '1'">
          <xsl:call-template name="link-script">
            <xsl:with-param name="files">
              <file>js/jquery.unveil.js</file>
              <file>fancybox/jquery.fancybox.js</file>
              <file>fancybox/helpers/jquery.fancybox-extras.js</file>
            </xsl:with-param>
          </xsl:call-template>
          <script type="text/javascript"><xsl:comment>
            jQuery(document).ready( function() {
              jQuery('.image-thumbnail-link').fancybox({
                helpers:  {
                  title : {
                    type : 'inside'
                  },
                  description : {
                    type : 'inside'
                  },
                  extras : {
                    type : 'float',
                    position: 'top',
                    linkTitle : 'Show comments',
                    urls : [
                      <xsl:for-each select="/page/content/topic/images/image">
                        <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                        <xsl:call-template name="javascript-escape-string">
                          <xsl:with-param name="string"
                            select="./following::*[position() &lt; 3 and name() = 'image-extras-link']" />
                        </xsl:call-template>
                      </xsl:for-each>
                    ]
                  }
                }
              });
              jQuery("img.thumbnail").unveil();
            });
          </xsl:comment></script>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="link-script">
            <xsl:with-param name="files">
              <file>js/jquery.unveil.js</file>
            </xsl:with-param>
          </xsl:call-template>
          <script type="text/javascript"><xsl:comment>
            jQuery(document).ready( function() {
              jQuery("img.thumbnail").unveil();
            });
          </xsl:comment></script>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-image-gallery">
    <xsl:param name="pageContent"/>
    <xsl:if test="$pageContent/title">
      <xsl:call-template name="module-content-topic">
        <xsl:with-param name="pageContent" select="$pageContent" />
        <xsl:with-param name="withHook" select="true()" />
        <xsl:with-param name="withText" select="not($pageContent/image)" />
      </xsl:call-template>
    </xsl:if>

    <xsl:call-template name="alert">
      <xsl:with-param name="message" select="$pageContent/message" />
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="count($pageContent/images/image) &gt; 0 or count($pageContent/image) &gt; 0">
        <div class="gallery">
          <a name="gallery-images-area"><xsl:text> </xsl:text></a>
          <xsl:call-template name="module-content-gallery-navigation">
            <xsl:with-param name="navigation" select="$pageContent/navigation" />
            <xsl:with-param name="anchor" select="'gallery-images-area'" />
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="$pageContent/images/image">
              <xsl:variable name="rows" select="ceiling(count($pageContent/images/image)
                div $pageContent/options/max_per_line)" />
              <xsl:call-template name="module-content-gallery-image-rows">
                <xsl:with-param name="images" select="$pageContent/images/image" />
                <xsl:with-param name="rows" select="$rows" />
                <xsl:with-param name="fieldsPerRow" select="$pageContent/options/max_per_line" />
                <xsl:with-param name="lightbox" select="$pageContent/options/lightbox" />
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

          <xsl:call-template name="module-content-gallery-navigation">
            <xsl:with-param name="navigation" select="$pageContent/navigation" />
            <xsl:with-param name="anchor" select="'gallery-images-area'" />
          </xsl:call-template>
        </div>
      </xsl:when>
      <xsl:when test="not($pageContent/message)">
        <xsl:call-template name="alert">
          <xsl:with-param name="type" select="'error'" />
          <xsl:with-param name="message" select="'GALLERY_NO_IMAGES'" />
          <xsl:with-param name="useLanguageText" select="true()" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="module-content-gallery-image-rows">
    <xsl:param name="images" />
    <xsl:param name="rows" />
    <xsl:param name="row" select="'1'" />
    <xsl:param name="fieldsPerRow" />
    <xsl:param name="lightbox" />
    <xsl:param name="position" select="'1'" />

    <xsl:if test="$position = 1 or ($position mod $fieldsPerRow = 1)">
      <xsl:variable name="anchor">gallery-row<xsl:value-of select="$row" /></xsl:variable>
      <a name="{$anchor}"><xsl:text> </xsl:text></a>

      <div class="row-fluid">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$row * $fieldsPerRow &lt; count($images)">row-fluid</xsl:when>
            <xsl:otherwise>row-fluid last</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="module-content-gallery-images">
          <xsl:with-param name="images" select="$images" />
          <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
          <xsl:with-param name="lightbox" select="$lightbox" />
          <xsl:with-param name="position" select="$position" />
          <xsl:with-param name="row" select="$row" />
          <xsl:with-param name="anchor" select="$anchor" />
        </xsl:call-template>
      </div>
    </xsl:if>

    <xsl:if test="$row &lt; $rows">
      <xsl:call-template name="module-content-gallery-image-rows">
        <xsl:with-param name="images" select="$images" />
        <xsl:with-param name="rows" select="$rows" />
        <xsl:with-param name="row" select="$row + 1" />
        <xsl:with-param name="fieldsPerRow" select="$fieldsPerRow" />
        <xsl:with-param name="lightbox" select="$lightbox" />
        <xsl:with-param name="position" select="$position + $fieldsPerRow" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-gallery-images">
    <xsl:param name="isSingleImage" select="false()" />
    <xsl:param name="images" select="false()" />
    <xsl:param name="navigation" select="false()" />
    <xsl:param name="fieldsPerRow" select="'0'" />
    <xsl:param name="lightbox" select="'0'" />
    <xsl:param name="position" select="'1'" />
    <xsl:param name="allowTitle" select="false()" />
    <xsl:param name="allowDescription" select="false()" />
    <xsl:param name="row" select="false()" />
    <xsl:param name="anchor" select="''" />

    <xsl:if test="$images">
      <xsl:variable name="currentImage" select="$images[position() = $position]" />

      <xsl:if test="$currentImage">
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
              <a href="{$navigation/navlink[@direction = 'index']/@href}#gallery-images-area">
                <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}"/>
              </a>
            </xsl:when>
            <xsl:when test="$currentImage/destination and $currentImage/destination/@href">
              <xsl:variable name="options" select="/page/content/topic/options" />
              <script><xsl:comment>
                document.write(
                  '&lt;div style="width: <xsl:value-of select="$options/thumb_width" />px; ' +
                  'height: <xsl:value-of select="$options/thumb_height" />px;"' +
                  'data-image-position="<xsl:value-of select="$position" />"&gt; &lt;/div&gt;'
                );
              </xsl:comment></script>
              <noscript>
                <a href="{$currentImage/destination/@href}#gallery-images-area" title="{$currentImage/title}">
                  <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}" />
                </a>
              </noscript>
            </xsl:when>
            <xsl:otherwise>
              <img class="thumbnail" src="{$currentImage/img/@src}" alt="{$currentImage/img/@alt}"/>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="$currentImage/following::*[position() &lt; 3 and name() = 'delete-image']">
            <div class="moderator-controls">
              <a class="btn btn-mini">
                <xsl:attribute name="href">
                  <xsl:value-of select="$currentImage/*[position() &lt; 3 and name() = 'delete-image']/@href" />
                  <xsl:if test="$anchor != ''">
                    <xsl:text>#</xsl:text><xsl:value-of select="$anchor" />
                  </xsl:if>
                </xsl:attribute>
                <i class="icon-remove"><xsl:text> </xsl:text></i><xsl:text> </xsl:text>
                <xsl:call-template name="language-text">
                  <xsl:with-param name="text" select="'GALLERY_DELETE_IMAGE'"/>
                </xsl:call-template>
              </a>
            </div>
          </xsl:if>

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
            <xsl:with-param name="lightbox" select="$lightbox" />
            <xsl:with-param name="position" select="$position + 1" />
            <xsl:with-param name="row" select="$row" />
            <xsl:with-param name="anchor" select="$anchor" />
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-gallery-navigation">
    <xsl:param name="navigation" />
    <xsl:param name="anchor" />
    <xsl:if test="$navigation/navlink[(@direction = 'previous') or (@direction = 'next')]">
      <div class="pagination">
        <ul>
          <xsl:if test="$navigation/navlink[@direction = 'previous']">
            <li><a href="{$navigation/navlink[@direction = 'previous']/@href}#{$anchor}">&#171;</a></li>
          </xsl:if>
          <xsl:if test="$navigation/navlink[@direction = 'index']">
            <li><a href="{$navigation/navlink[@direction = 'index']/@href}#{$anchor}">
              <xsl:call-template name="language-text">
                <xsl:with-param name="text" select="'GALLERY_INDEX'"/>
              </xsl:call-template></a></li>
          </xsl:if>
          <xsl:if test="$navigation/navlink[@direction = 'next']">
            <li><a href="{$navigation/navlink[@direction = 'next']/@href}#{$anchor}">&#187;</a></li>
          </xsl:if>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>