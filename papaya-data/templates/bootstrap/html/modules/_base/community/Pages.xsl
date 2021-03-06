<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="PAGE_LANGUAGE"></xsl:param>
  <xsl:param name="LANGUAGE_MODULE_CURRENT" select="document(concat($PAGE_LANGUAGE, '.xml'))" />
  <xsl:param name="LANGUAGE_MODULE_FALLBACK" select="document('en-US.xml')"/>

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
    <xsl:call-template name="content-message">
      <xsl:with-param name="pageContent" select="$pageContent" />
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$pageContent/login">
        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/login" />
          <xsl:with-param name="horizontal" select="true()" />
          <xsl:with-param name="submitButton">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_FORM_LOGIN</xsl:with-param>
              <xsl:with-param name="userText" select="$pageContent/captions/login-button/text()"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
        <div class="login-form-additional-hint">
          <a href="{$pageContent/login/@chglink}">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_FORM_PASSWORD_FORGOTTEN</xsl:with-param>
              <xsl:with-param name="userText" select="$pageContent/captions/passwd-link/text()"/>
            </xsl:call-template>
          </a>
        </div>
      </xsl:when>
      <xsl:when test="$pageContent/passwordrequest">
        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/passwordrequest" />
          <xsl:with-param name="horizontal" select="true()" />
          <xsl:with-param name="captions" select="$pageContent/captions" />
          <xsl:with-param name="submitButton">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_FORM_REQUEST_PASSWORD</xsl:with-param>
              <xsl:with-param name="userText" select="$pageContent/captions/request-button/text()"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/passwordchange">
        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/passwordchange" />
          <xsl:with-param name="horizontal" select="true()" />
          <xsl:with-param name="captions" select="$pageContent/captions" />
          <xsl:with-param name="submitButton">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_FORM_SAVE</xsl:with-param>
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
    <xsl:call-template name="content-message">
      <xsl:with-param name="pageContent" select="$pageContent" />
    </xsl:call-template>
    <xsl:if test="$pageContent/userdata/dialog">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/userdata/dialog" />
        <xsl:with-param name="horizontal" select="true()" />
        <xsl:with-param name="inputSize" select="'xxlarge'" />
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$pageContent/delete-account">
      <xsl:call-template name="dialog">
        <xsl:with-param name="dialog" select="$pageContent/delete-account/dialog" />
        <xsl:with-param name="horizontal" select="false()" />
        <xsl:with-param name="legend" select="$pageContent/delete-account/headline" />
      </xsl:call-template>
      <span class="help-block"><xsl:value-of select="$pageContent/delete-account/description" /></span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="module-content-profile-change-confirmation">
    <xsl:param name="pageContent"/>
    <xsl:choose>
      <xsl:when test="$pageContent/dialog">

        <xsl:call-template name="module-content-topic">
          <xsl:with-param name="pageContent" select="$pageContent" />
          <xsl:with-param name="withText" select="$pageContent/description" />
        </xsl:call-template>

        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/error" />
          <xsl:with-param name="type" select="'error'" />
        </xsl:call-template>
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/message" />
        </xsl:call-template>

        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/dialog"/>
          <xsl:with-param name="horizontal" select="true()" />
          <xsl:with-param name="inputSize" select="'xxlarge'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/message" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="module-content-community-register-dynamic">
    <xsl:param name="pageContent"/>
    <xsl:call-template name="module-content-topic">
      <xsl:with-param name="pageContent" select="$pageContent" />
    </xsl:call-template>

    <xsl:call-template name="content-message">
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

        <xsl:call-template name="dialog">
          <xsl:with-param name="dialog" select="$pageContent/registerpage/dialog" />
          <xsl:with-param name="horizontal" select="true()" />
          <xsl:with-param name="termsText" select="$pageContent/registerpage/terms" />
          <xsl:with-param name="class" select="'surfer-registration-dialog'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/registerpage/success|$pageContent/registerpage/message[@type='success']">
        <xsl:if test="$pageContent/registerpage/text">
          <xsl:copy-of select="$pageContent/registerpage/text/*|$pageContent/registerpage/text/text()"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$pageContent/registered">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/registered/node()" />
          <xsl:with-param name="type" select="'success'" />
        </xsl:call-template>
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

  <xsl:template name="content-message">
    <xsl:param name="pageContent" select="/page/content/topic" />

    <xsl:choose>
      <xsl:when test="$pageContent/error|$pageContent/message[@type = 'error']">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/error|$pageContent/message[@type = 'error']" />
          <xsl:with-param name="type" select="'error'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/message[@type = 'success']">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/message" />
          <xsl:with-param name="type" select="success" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pageContent/message">
        <xsl:call-template name="alert">
          <xsl:with-param name="message" select="$pageContent/message" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="papaya-login-error">
    <xsl:param name="pageContent" select="/page/content/topic" />

    <xsl:if test="$pageContent/login/error">
      <xsl:variable name="message">
        <xsl:choose>
          <xsl:when test="$pageContent/login/error/@no = '700'">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_ERROR_UNKNOWN_ERROR</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pageContent/login/error/@no = '701'">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_ERROR_INVALID_PASSWORD</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pageContent/login/error/@no = '702'">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_ERROR_INVALID_USERNAME</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pageContent/login/error/@no = '703'">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_ERROR_ACCOUNT_BLOCKED</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pageContent/login/error/@no = '704'">
            <xsl:call-template name="language-text">
              <xsl:with-param name="text">LOGIN_ERROR_INVALID_PERMISSIONS</xsl:with-param>
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
      </xsl:variable>

      <xsl:call-template name="alert">
        <xsl:with-param name="type" select="'error'" />
        <xsl:with-param name="message" select="$message" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>