<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="./Ui/Content/Comments.xsl"/>
  <xsl:import href="./Ui/Content/Paging.xsl"/>
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
              <li><a href="{active-surfer/groups-link}"><xsl:value-of select="active-surfer/groups-link/@caption" /></a></li>
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

  <xsl:template match="surfer[@mode = 'surfer-bar']">
    <div class="navbar ressource-context">
      <div class="navbar-inner">
        <a class="brand" href="{details/group/detail[@name = 'page-link']}">
          <img src="{details/group/detail[@name = 'avatar']}" alt="" class="pull-left" /></a>
        <div class="links">
          <a class="brand" href="{details/group/detail[@name = 'page-link']}">
            <xsl:value-of select="details/group/detail[@name = 'name']" /></a>
          <ul class="nav">
            <li>
              <xsl:if test="details/group/detail[@name = 'gallery-link']/@active = '1'">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a href="{details/group/detail[@name = 'gallery-link']/@href}">
                <xsl:value-of select="details/group/detail[@name = 'gallery-link']/@caption" /></a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="group[@mode = 'group-bar']">
    <div class="navbar ressource-context">
      <div class="navbar-inner">
        <a class="brand" href="{page-link}"><img src="{image}" alt="" class="pull-left" /></a>
        <div class="links">
          <a class="brand" href="{page-link}"><xsl:value-of select="title" /></a>
          <xsl:if test="count(commands/*) &gt; 0">
            <ul class="nav">
              <xsl:for-each select="commands/*">
                <li>
                  <xsl:if test="@active = '1'">
                    <xsl:attribute name="class">active</xsl:attribute>
                  </xsl:if>
                  <a href="{@href}"><xsl:value-of select="@caption" /></a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </div>
      </div>
    </div>
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

  <xsl:template match="acommunity-image-gallery-teaser">
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

  <xsl:template match="acommunity-image-gallery-upload">
    <xsl:call-template name="dialog">
      <xsl:with-param name="dialog" select="dialog-box" />
      <xsl:with-param name="inline" select="true()" />
      <xsl:with-param name="class" select="'gallery-upload-dialog'" />
      <xsl:with-param name="message" select="dialog-message" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="acommunity-image-gallery-folders">
    <xsl:if test="count(folders/folder) &gt; 0">
      <xsl:variable name="commandLinks" select="command-links" />
      <ul class="nav nav-tabs gallery-folders">
        <xsl:for-each select="folders/folder">
          <xsl:variable name="folderId" select="@id" />
          <li>
            <xsl:if test="$commandLinks and $commandLinks/command-link[@folder_id = $folderId and @name = 'delete_folder']">
              <xsl:attribute name="class">gallery-folder-with-command-delete</xsl:attribute>
            </xsl:if>
            <xsl:if test="@selected = '1'">
              <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{@href}"><xsl:value-of select="@name" /></a>
          </li>
          <xsl:if test="$commandLinks and $commandLinks/command-link[@folder_id = $folderId and @name = 'delete_folder']">
            <li class="gallery-folder-command-delete">
              <a href="{$commandLinks/command-link[@folder_id = $folderId and @name = 'delete_folder']}"
                 title="{$commandLinks/command-link[@folder_id = $folderId and @name = 'delete_folder']/@caption} {@name}">
                <i class="icon-remove"><xsl:text> </xsl:text></i>
              </a>
            </li>
          </xsl:if>
        </xsl:for-each>
        <xsl:if test="command-links/command-link[@name = 'add_folder']">
          <li>
            <a href="{command-links/command-link[@name = 'add_folder']}">
            <xsl:value-of select="command-links/command-link[@name = 'add_folder']/@caption" /></a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
    <xsl:call-template name="dialog">
      <xsl:with-param name="dialog" select="dialog-box" />
      <xsl:with-param name="inline" select="true()" />
      <xsl:with-param name="className" select="'add-folder-dialog'" />
      <xsl:with-param name="inputSize" select="'xxlarge'" />
      <xsl:with-param name="message" select="dialog-message" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="acommunity-message-conversations">
    <xsl:if test="message">
      <xsl:call-template name="alert">
        <xsl:with-param name="message" select="message" />
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="count(conversations/conversation) &gt; 0">
      <xsl:for-each select="conversations/conversation">
        <div class="media conversation">
          <a class="pull-left" href="{messages-page-link}"><img class="media-object" alt="" src="{surfer-contact/@avatar}" /></a>
          <div class="media-body">
            <h4 class="media-heading"><a href="{messages-page-link}"><xsl:value-of select="surfer-contact/@name" /></a></h4>
            <p><xsl:call-template name="acommunity-message-conversations-get-last-message-text">
              <xsl:with-param name="text" select="last-message/text-raw" />
              <xsl:with-param name="maxLength" select="last-message/@max-length" />
            </xsl:call-template><br />
            <small><xsl:call-template name="format-date-time">
              <xsl:with-param name="dateTime" select="last-message/@time" />
            </xsl:call-template></small></p>
          </div>
        </div>
      </xsl:for-each>
      <xsl:call-template name="acommunity-content-paging">
        <xsl:with-param name="paging" select="conversations/paging" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="acommunity-message-conversations-get-last-message-text">
    <xsl:param name="text" />
    <xsl:param name="maxLength" />
    <xsl:choose>
      <xsl:when test="string-length($text) &gt; $maxLength">
        <xsl:value-of select="substring($text, 1, $maxLength - 1)" /><xsl:text>...</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>