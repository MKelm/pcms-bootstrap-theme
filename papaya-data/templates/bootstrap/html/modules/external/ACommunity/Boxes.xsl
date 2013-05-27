<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="./Ui/Content/Comments.xsl"/>
  <xsl:import href="./Ui/Content/Surfers.xsl"/>
  <xsl:import href="../../../base/dialogs.xsl"/>

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat($PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('en-US.xml')"/>

  <xsl:template match="acommunity-comments">
    <xsl:call-template name="acommunity-comments">
      <xsl:with-param name="commandName" select="command/@name" />
      <xsl:with-param name="commandCommentId" select="command/@comment_id" />
      <xsl:with-param name="comments" select="comments" />
      <xsl:with-param name="dialog" select="dialog-box" />
      <xsl:with-param name="dialogMessage" select="dialog-message" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="acommunity-surfer-status">
    <xsl:choose>
      <xsl:when test="active-surfer">
        <ul class="nav pull-right">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><img class="surfer-status-image" src="{active-surfer/@avatar}" alt="" /> <xsl:value-of select="active-surfer/@name" /> <b class="caret"><xsl:text> </xsl:text></b></a>
            <ul class="dropdown-menu">
              <li><a href="{active-surfer/page-link}"><xsl:call-template name="language-text">
                <xsl:with-param name="text" select="'SURFER_NAV_PROFILE_LINK'"/>
              </xsl:call-template></a></li>
              <li><a href="{active-surfer/edit-link}"><xsl:value-of select="active-surfer/edit-link/@caption" /></a></li>
              <li><a href="{active-surfer/messages-link}"><xsl:value-of select="active-surfer/messages-link/@caption" /></a></li>
              <xsl:if test="active-surfer/contacts-link or active-surfer/contact-requests-link or active-surfer/contact-own-requests-link">
                <li class="nav-header"><xsl:call-template name="language-text">
                  <xsl:with-param name="text" select="'SURFER_NAV_CONTACTS_HEADER'"/>
                </xsl:call-template></li>
                <xsl:if test="active-surfer/contacts-link">
                 <li><a href="{active-surfer/contacts-link}"><xsl:value-of select="active-surfer/contacts-link/@caption" /></a></li>
                </xsl:if>
                <xsl:if test="active-surfer/contact-own-requests-link">
                 <li><a href="{active-surfer/contact-own-requests-link}"><xsl:value-of select="active-surfer/contact-own-requests-link/@caption" /></a></li>
                </xsl:if>
                <xsl:if test="active-surfer/contact-requests-link">
                 <li><a href="{active-surfer/contact-requests-link}"><xsl:value-of select="active-surfer/contact-requests-link/@caption" /></a></li>
                </xsl:if>
              </xsl:if>
              <li class="nav-header"><xsl:call-template name="language-text">
                <xsl:with-param name="text" select="'SURFER_NAV_NOTIFICATIONS_HEADER'"/>
              </xsl:call-template></li>
              <li><a href="{active-surfer/notifications-link}"><xsl:value-of select="active-surfer/notifications-link/@caption" /></a></li>
              <li><a href="{active-surfer/notification-settings-link}"><xsl:value-of select="active-surfer/notification-settings-link/@caption" /></a></li>
              <li class="divider" />
              <li><a href="{active-surfer/logout-link}"><xsl:value-of select="active-surfer/logout-link/@caption" /></a></li>
            </ul>
          </li>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <p class="navbar-text pull-right">
          <xsl:apply-templates select="message[@type = 'no-login']" />
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- replace a tags in header navigation surfer status box -->
  <xsl:template match="message[@type = 'no-login']/a">
    <a class="navbar-link" href="{@href}"><xsl:value-of select="." /></a>
  </xsl:template>

  <xsl:template match="acommunity-surfers">
    <xsl:call-template name="acommunity-surfers">
      <xsl:with-param name="content" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="acommunity-commenters-ranking">
    <xsl:if test="count(commenter) &gt; 0">
      <xsl:for-each select="commenter">
        <div class="media commenter">
          <a class="pull-left" href="{surfer/@page-link}"><img class="media-object" alt="" src="{surfer/@avatar}" /></a>
          <div class="media-body">
            <h4 class="media-heading"><a href="{surfer/@page-link}"><xsl:value-of select="surfer/@name" /></a></h4>
            <p><xsl:value-of select="comments/@amount" /><xsl:text> </xsl:text><xsl:value-of select="comments/@caption" /></p>
          </div>
        </div>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="acommunity-surfer-gallery-teaser">
    <xsl:if test="add-new-images-link/@href or count(images/image) &gt; 0">
      <ul class="inline gallery-teaser">
        <xsl:variable name="moreImagesLink" select="more-images-link/@href" />
        <xsl:for-each select="images/image">
          <li><a href="{$moreImagesLink}"><img class="thumbnail" src="{@src}" alt="" /></a></li>
        </xsl:for-each>
        <xsl:if test="more-images-link/@href">
          <li class="more-link"><a href="{more-images-link/@href}"><xsl:value-of select="more-images-link" disable-output-escaping="yes" /></a></li>
        </xsl:if>
      </ul>
    </xsl:if>
    <xsl:if test="add-new-images-link/@href">
      <ul class="unstyled gallery-teaser">
        <li class="new-images-linK">
          <a href="{add-new-images-link/@href}"><xsl:value-of select="add-new-images-link" /></a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="acommunity-surfer-gallery-upload">
    <xsl:call-template name="dialog">
      <xsl:with-param name="dialog" select="dialog-box" />
      <xsl:with-param name="inline" select="true()" />
      <xsl:with-param name="class" select="'gallery-upload'" />
    </xsl:call-template>
    <xsl:if test="dialog-message">
      <xsl:call-template name="alert">
        <xsl:with-param name="message" select="dialog-message" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>