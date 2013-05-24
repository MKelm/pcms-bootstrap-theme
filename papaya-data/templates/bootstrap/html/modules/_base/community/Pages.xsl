<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="page-styles">
</xsl:template>

<xsl:template name="content-area">
  <xsl:param name="pageContent" select="content/topic"/>
  <xsl:choose>
    <xsl:when test="$pageContent/@module = 'content_login'">
      <xsl:call-template name="module-content-community-login">
        <xsl:with-param name="pageContent" select="$pageContent"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pageContent/@module = 'content_profile'">
      <xsl:call-template name="module-content-community-profile">
        <xsl:with-param name="pageContent" select="$pageContent"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pageContent/@module = 'content_register'">
      <xsl:call-template name="module-content-community-register-dynamic">
        <xsl:with-param name="pageContent" select="$pageContent"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pageContent/@module = 'content_profile_change_confirmation'">
      <xsl:call-template name="module-content-profile-change-confirmation">
        <xsl:with-param name="pageContent" select="$pageContent"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="module-content-community-login">
  <xsl:param name="pageContent"/>
  <xsl:call-template name="module-content-topic">
    <xsl:with-param name="pageContent" select="$pageContent" />
  </xsl:call-template>
  <xsl:if test="$pageContent/verified">
    <div>
      <xsl:copy-of select="$pageContent/verified/*|$pageContent/verified/text()"/>
    </div>
  </xsl:if>
  <xsl:call-template name="papaya-login-error" />
  <xsl:choose>
    <xsl:when test="$pageContent/login">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/login" />
        <xsl:with-param name="captions" select="$pageContent/captions" />
        <xsl:with-param name="submitButton">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">LOGIN</xsl:with-param>
            <xsl:with-param name="userText" select="$pageContent/captions/login-button/text()"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
      <a href="{$pageContent/login/@chglink}">
        <xsl:call-template name="language-text">
          <xsl:with-param name="text">PASSWORD_FORGOTTEN</xsl:with-param>
          <xsl:with-param name="userText" select="$pageContent/captions/passwd-link/text()"/>
        </xsl:call-template>
      </a>
    </xsl:when>
    <xsl:when test="$pageContent/passwordrequest">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/passwordrequest" />
        <xsl:with-param name="captions" select="$pageContent/captions" />
        <xsl:with-param name="submitButton">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">REQUEST_PASSWORD</xsl:with-param>
            <xsl:with-param name="userText" select="$pageContent/captions/request-button/text()"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pageContent/passwordchange">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/passwordchange" />
        <xsl:with-param name="captions" select="$pageContent/captions" />
        <xsl:with-param name="submitButton">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">SAVE</xsl:with-param>
            <xsl:with-param name="userText" select="$pageContent/captions/save-button/text()"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="module-content-community-profile">
  <xsl:param name="pageContent"/>
  <xsl:call-template name="module-content-topic">
    <xsl:with-param name="pageContent" select="$pageContent" />
  </xsl:call-template>
  <xsl:if test="$pageContent/userdata/dialog">
    <div class="userProfile">
      <!-- TODO these are extra help texts that were intended to be placed before specific field elements
      <div><xsl:apply-templates select="$pageContent/descr-change-email/node()" /></div>
      <div><xsl:apply-templates select="$pageContent/descr-change-password/node()" /></div>
       -->
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/userdata/dialog" />
      </xsl:call-template>
    </div>
  </xsl:if>
  <xsl:if test="$pageContent/delete-account">
    <div class="deleteAccount">
      <h2><xsl:value-of select="$pageContent/delete-account/headline/text()"/></h2>
      <div><xsl:apply-templates select="$pageContent/delete-account/description/node()"/></div>
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/delete-account/dialog" />
      </xsl:call-template>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="module-content-profile-change-confirmation">
  <xsl:param name="pageContent"/>
  <xsl:choose>
    <xsl:when test="$pageContent/dialog">
      <h2><xsl:value-of select="$pageContent/title/text()"/></h2>
      <p><xsl:value-of select="$pageContent/description/text()"/></p>
      <xsl:if test="$pageContent/error|$pageContent/message[@type = 'error']">
        <p class="error">
          <xsl:value-of select="$pageContent/error/text()|$pageContent/message[@type = 'error']/text()"/>
        </p>
      </xsl:if>
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/dialog"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$pageContent/message">
        <xsl:copy-of select="$pageContent/message/*|$pageContent/message/text()" />
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="module-content-community-register-dynamic">
  <xsl:param name="pageContent"/>
  <xsl:call-template name="module-content-topic">
    <xsl:with-param name="pageContent" select="$pageContent" />
  </xsl:call-template>

  <xsl:call-template name="papaya-error">
    <xsl:with-param name="pageContent" select="$pageContent/registerpage" />
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="$pageContent/registerpage/dialog">
      <xsl:if test="$pageContent/registerpage/text">
        <xsl:copy-of select="$pageContent/registerpage/text/*|$pageContent/registerpage/text/text()"/>
      </xsl:if>
      <xsl:if test="$pageContent/registerpage/summary/*">
        <xsl:for-each select="$pageContent/registerpage/summary/*">
          <p>
            <strong><xsl:value-of select="@caption"/>:</strong>
            <xsl:text> </xsl:text>
            <xsl:value-of select="text()"/>
          </p>
        </xsl:for-each>
      </xsl:if>
      <div class="userRegistration">
        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/registerpage/dialog" />
          <xsl:with-param name="terms" select="$pageContent/registerpage/terms" />
        </xsl:call-template>
      </div>
    </xsl:when>
    <xsl:when test="$pageContent/registerpage/success|$pageContent/registerpage/message[@type='success']">
      <div class="message">
        <xsl:apply-templates select="$pageContent/registerpage/success/node()|$pageContent/registerpage/message[@type='success']/node()" />
      </div>
      <xsl:if test="$pageContent/registerpage/text">
        <xsl:copy-of select="$pageContent/registerpage/text/*|$pageContent/registerpage/text/text()"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$pageContent/registered">
      <div class="message">
        <xsl:apply-templates select="$pageContent/registered/node()" />
      </div>
      <xsl:if test="$pageContent/registerpage/text">
        <xsl:copy-of select="$pageContent/registerpage/text/*|$pageContent/registerpage/text/text()"/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$pageContent/registerpage/text">
        <xsl:copy-of select="$pageContent/registerpage/text/*|$pageContent/registerpage/text/text()"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="papaya-error">
  <xsl:param name="pageContent" select="/page/content/topic" />

  <xsl:if test="$pageContent/error|$pageContent/message[@type = 'error']">
    <div class="error">
      <xsl:apply-templates select="$pageContent/error/node()|$pageContent/message[@type = 'error']/node()" />
    </div>
  </xsl:if>
  <xsl:if test="$pageContent/message[@type != 'error' and @type != 'success']">
    <div class="message">
      <xsl:apply-templates select="$pageContent/message/node()" />
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="papaya-login-error">
  <xsl:param name="pageContent" select="/page/content/topic" />

  <xsl:if test="$pageContent/login/error">
    <div class="error">
      <xsl:choose>
        <!-- the human readable error description in the xml is not translated -->
        <xsl:when test="$pageContent/login/error/@no = '700'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">UNKNOWN_ERROR</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pageContent/login/error/@no = '701'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">INVALID_PASSWORD</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pageContent/login/error/@no = '702'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">INVALID_USERNAME</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pageContent/login/error/@no = '703'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">ACCOUNT_BLOCKED</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pageContent/login/error/@no = '704'">
          <xsl:call-template name="language-text">
            <xsl:with-param name="text">INVALID_PERMISSIONS</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pageContent/login/error"/>
          <xsl:message>
            <xsl:text>Login error that is not yet translated (No. </xsl:text>
            <xsl:value-of select="$pageContent/login/error/@no" />
            <xsl:text>): </xsl:text>
            <xsl:value-of select="$pageContent/login/error" />
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:if>
</xsl:template>

<!-- The dialog and dialog-content templates have been copied from base/dialogs.xsl
     to allow for special treatment of the terms dialog element using HTML caption -->

<xsl:template name="dialog">
  <xsl:param name="dialog" />
  <xsl:param name="title" select="''" />
  <xsl:param name="id" select="''" />
  <xsl:param name="showMandatory" select="true()" />
  <xsl:param name="submitButton" select="''" />
  <xsl:param name="captions" select="false()" />
  <xsl:param name="terms" />
  <xsl:param name="userDataDescriptions" select="false()" />
  <xsl:if test="$dialog">
    <xsl:variable name="idVal">
      <xsl:choose>
        <xsl:when test="$id and $id != ''"><xsl:value-of select="$id"/></xsl:when>
        <xsl:when test="$dialog/@id and $dialog/@id != ''"><xsl:value-of select="$dialog/@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id($dialog)" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form id="{$idVal}" action="{$dialog/@action}">
      <xsl:copy-of select="$dialog/@*[name() = 'onclick']" />
      <xsl:attribute name="method">
        <xsl:choose>
          <xsl:when test="$dialog/@method"><xsl:value-of select="$dialog/@method"/></xsl:when>
          <xsl:otherwise>post</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="count($dialog//input[@type = 'file']) &gt; 0">
          <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
        </xsl:when>
        <xsl:when test="$dialog/@encoding">
          <xsl:attribute name="enctype"><xsl:value-of select="$dialog/@encoding" /></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:copy-of select="$dialog/input[@type='hidden']"/>
      <xsl:call-template name="dialog-content">
        <xsl:with-param name="dialog" select="$dialog" />
        <xsl:with-param name="title" select="$title" />
        <xsl:with-param name="id" select="$idVal" />
        <xsl:with-param name="showMandatory" select="$showMandatory" />
        <xsl:with-param name="submitButton" select="$submitButton" />
        <xsl:with-param name="captions" select="$captions" />
        <xsl:with-param name="terms" select="$terms" />
        <xsl:with-param name="userDataDescriptions" select="$userDataDescriptions" />
      </xsl:call-template>
    </form>
  </xsl:if>
</xsl:template>

<xsl:template name="dialog-content">
  <xsl:param name="dialog" />
  <xsl:param name="title" />
  <xsl:param name="id" />
  <xsl:param name="showMandatory" select="true()" />
  <xsl:param name="submitButton"/>
  <xsl:param name="captions"/>
  <xsl:param name="terms" />
  <xsl:param name="userDataDescriptions" select="false()" />
  <xsl:if test="$title and $title != ''">
    <h2><xsl:value-of select="$title" /></h2>
  </xsl:if>
  <fieldset>
    <xsl:choose>
      <xsl:when test="$dialog/lines">
        <xsl:choose>
          <xsl:when test="$dialog/lines/linegroup">
            <xsl:for-each select="$dialog/lines/linegroup">
              <xsl:if test="@caption and @caption != ''">
                <h2><xsl:value-of select="@caption" /></h2>
              </xsl:if>
              <xsl:call-template name="dialog-content-lines">
                <xsl:with-param name="dialog" select="$dialog" />
                <xsl:with-param name="lines" select="line"/>
                <xsl:with-param name="showMandatory" select="$showMandatory" />
                <xsl:with-param name="userDataDescriptions" select="$userDataDescriptions" />
                <xsl:with-param name="terms" select="$terms" />
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dialog-content-lines">
              <xsl:with-param name="dialog" select="$dialog" />
              <xsl:with-param name="lines" select="$dialog/lines//line"/>
              <xsl:with-param name="showMandatory" select="$showMandatory" />
              <xsl:with-param name="userDataDescriptions" select="$userDataDescriptions" />
              <xsl:with-param name="terms" select="$terms" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$dialog/element/*">
        <xsl:for-each select="$dialog/element">
          <xsl:call-template name="dialog-field">
            <xsl:with-param name="dialog" select="$dialog" />
            <xsl:with-param name="field" select="." />
            <xsl:with-param name="showMandatory" select="$showMandatory" />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:copy-of select="//terms/*|//terms/text()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$dialog/*">
          <xsl:call-template name="dialog-direct-element">
            <xsl:with-param name="dialog" select="$dialog" />
            <xsl:with-param name="element" select="." />
            <xsl:with-param name="showMandatory" select="$showMandatory" />
            <xsl:with-param name="captions" select="$captions" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="dialog-buttons">
      <xsl:with-param name="dialog" select="$dialog" />
      <xsl:with-param name="id" select="$id" />
      <xsl:with-param name="submitButton" select="$submitButton" />
    </xsl:call-template>
  </fieldset>
</xsl:template>

<xsl:template name="dialog-content-lines">
  <xsl:param name="dialog" />
  <xsl:param name="lines" />
  <xsl:param name="showMandatory" select="true()" />
  <xsl:param name="userDataDescriptions" select="false()" />
  <xsl:param name="terms" />

  <xsl:for-each select="$lines[@fid != 'terms']">
    <xsl:if test="$userDataDescriptions != false()">
      <xsl:choose>
        <xsl:when test="@fid = 'surfer_password_1'">
          <p class="description">
            <xsl:value-of select="$userDataDescriptions/description-change-password/@content" />
          </p>
        </xsl:when>
        <xsl:when test="@fid = 'surfer_new_email'">
          <p class="description">
            <xsl:value-of select="$userDataDescriptions/description-change-email/@content" />
          </p>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
    <xsl:call-template name="dialog-field">
      <xsl:with-param name="dialog" select="$dialog" />
      <xsl:with-param name="field" select="." />
      <xsl:with-param name="showMandatory" select="$showMandatory" />
    </xsl:call-template>
    <xsl:if test="$userDataDescriptions != false() and @fid = 'surfer_old_password'">
      <p class="description">
        <xsl:value-of select="$userDataDescriptions/description-enter-password/@content" />
      </p>
    </xsl:if>
  </xsl:for-each>
  <xsl:if test="$lines[@fid = 'terms']">
    <xsl:call-template name="dialog-field">
      <xsl:with-param name="dialog" select="$dialog" />
      <xsl:with-param name="field" select="$dialog/lines//line[@fid = 'terms']" />
      <xsl:with-param name="showMandatory" select="$showMandatory" />
    </xsl:call-template>
    <p><xsl:copy-of select="$terms" /></p>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>