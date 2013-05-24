<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat($PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('en-US.xml')"/>

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

  <xsl:template match="message[@type = 'no-login']/a">
    <a class="navbar-link" href="{@href}"><xsl:value-of select="." /></a>
  </xsl:template>

</xsl:stylesheet>