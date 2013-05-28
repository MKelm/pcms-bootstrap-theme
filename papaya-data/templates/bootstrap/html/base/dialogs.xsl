<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    IMPORTANT! DO NOT CHANGE THIS FILE!

    If you need to change one of the templates just define a template with the
    same name in your xsl file. This will override the imported template from
    this file.

    Supported inputSize values:
    mini, small, medium, large, xlarge, xxlarge

  -->

  <xsl:template name="dialog">
    <xsl:param name="dialog" />
    <xsl:param name="title" select="''" />
    <xsl:param name="legend" select="''" />
    <xsl:param name="id" select="''" />
    <xsl:param name="class" select="''" />
    <xsl:param name="showButtons" select="true()" />
    <xsl:param name="showMandatory" select="true()" />
    <xsl:param name="horizontal" select="false()" />
    <xsl:param name="inline" select="false()" />
    <xsl:param name="submitButton" select="false()" />
    <xsl:param name="captions" select="false()" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="parentAnchor" select="''" />
    <xsl:param name="message" select="''" />
    <xsl:param name="search" select="false()" />
    <xsl:param name="termsText" select="false()" />

    <xsl:if test="$message and $message != ''">
      <xsl:call-template name="alert">
        <xsl:with-param name="message" select="$message" />
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$dialog">
      <xsl:variable name="idVal">
        <xsl:choose>
          <xsl:when test="$id and $id != ''"><xsl:value-of select="$id"/></xsl:when>
          <xsl:when test="$dialog/@id and $dialog/@id != ''"><xsl:value-of select="$dialog/@id"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="generate-id($dialog)" /></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="actionAnchor">
        <xsl:choose>
          <xsl:when test="$parentAnchor != ''">#<xsl:value-of select="$parentAnchor" /></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <form id="{$idVal}" action="{$dialog/@action}{$actionAnchor}">
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
        <xsl:variable name="additionalClass">
          <xsl:choose>
            <xsl:when test="$class != ''">
              <xsl:text> </xsl:text><xsl:value-of select="$class" />
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$search = true()">
            <xsl:attribute name="class">navbar-form<xsl:value-of select="$additionalClass" /></xsl:attribute>
          </xsl:when>
          <xsl:when test="$horizontal = true()">
            <xsl:attribute name="class">form-horizontal<xsl:value-of select="$additionalClass" /></xsl:attribute>
          </xsl:when>
          <xsl:when test="$inline = true()">
            <xsl:attribute name="class">form-inline<xsl:value-of select="$additionalClass" /></xsl:attribute>
          </xsl:when>
          <xsl:when test="$class != ''">
            <xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:copy-of select="$dialog/input[@type='hidden']"/>
        <xsl:call-template name="dialog-content">
          <xsl:with-param name="dialog" select="$dialog" />
          <xsl:with-param name="title" select="$title" />
          <xsl:with-param name="legend" select="$legend" />
          <xsl:with-param name="id" select="$idVal" />
          <xsl:with-param name="horizontal" select="$horizontal" />
          <xsl:with-param name="inline" select="$inline" />
          <xsl:with-param name="search" select="$search" />
          <xsl:with-param name="showMandatory" select="$showMandatory" />
          <xsl:with-param name="showButtons" select="$showButtons" />
          <xsl:with-param name="submitButton" select="$submitButton" />
          <xsl:with-param name="captions" select="$captions" />
          <xsl:with-param name="inputSize" select="$inputSize" />
          <xsl:with-param name="termsText" select="$termsText" />
        </xsl:call-template>
      </form>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-content">
    <xsl:param name="dialog" />
    <xsl:param name="title" />
    <xsl:param name="legend" />
    <xsl:param name="id" />
    <xsl:param name="horizontal" />
    <xsl:param name="inline" />
    <xsl:param name="search" />
    <xsl:param name="showMandatory" select="true()" />
    <xsl:param name="showButtons" select="true()" />
    <xsl:param name="submitButton" select="false()" />
    <xsl:param name="captions" select="false()" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="termsText" select="false()" />

    <xsl:if test="$title and $title != ''">
      <h2><xsl:value-of select="$title" /></h2>
    </xsl:if>
    <xsl:if test="$legend and $legend != ''">
      <legend><xsl:value-of select="$legend" /></legend>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$dialog/field">
        <linegroup>
          <xsl:for-each select="$dialog/field">
            <xsl:choose>
              <xsl:when test="$horizontal = true() and $search = false()">
                <xsl:call-template name="dialog-control-group">
                  <xsl:with-param name="line" select="." />
                  <xsl:with-param name="showMandatory" select="$showMandatory" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="dialog-control-unit">
                  <xsl:with-param name="line" select="." />
                  <xsl:with-param name="showMandatory" select="$showMandatory" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                  <xsl:with-param name="search" select="$search" />
                  <xsl:with-param name="placeholder" select="$search = true()" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </linegroup>
      </xsl:when>
      <xsl:when test="$dialog/lines/linegroup">
        <xsl:for-each select="$dialog/lines/linegroup">
          <linegroup>
            <xsl:if test="@caption">
              <legend><xsl:value-of select="@caption" /></legend>
            </xsl:if>
            <xsl:if test="line">
              <xsl:for-each select="line[@fid != 'terms']">
                <xsl:choose>
                  <xsl:when test="$horizontal = true() and $search = false()">
                    <xsl:call-template name="dialog-control-group">
                      <xsl:with-param name="line" select="." />
                      <xsl:with-param name="showMandatory" select="$showMandatory" />
                      <xsl:with-param name="inputSize" select="$inputSize" />
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="dialog-control-unit">
                      <xsl:with-param name="line" select="." />
                      <xsl:with-param name="showMandatory" select="$showMandatory" />
                      <xsl:with-param name="inputSize" select="$inputSize" />
                      <xsl:with-param name="search" select="$search" />
                      <xsl:with-param name="placeholder" select="$search = true()" />
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:if test="$horizontal = true() and $search = false()">
                <xsl:for-each select="line[@fid = 'terms']">

                </xsl:for-each>
              </xsl:if>
            </xsl:if>
          </linegroup>
        </xsl:for-each>
        <xsl:if test="$termsText and $dialog/lines//line[@fid = 'terms']">
          <linegroup>
            <legend><xsl:value-of select="$dialog/lines//line[@fid = 'terms']/@caption" /></legend>
            <xsl:call-template name="dialog-control-group">
              <xsl:with-param name="line" select="$dialog/lines//line[@fid = 'terms']" />
              <xsl:with-param name="showMandatory" select="$showMandatory" />
              <xsl:with-param name="inputSize" select="$inputSize" />
              <xsl:with-param name="termsText" select="$termsText" />
            </xsl:call-template>
          </linegroup>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$dialog/element">
        <linegroup>
          <xsl:variable name="controlNamePrefix">
            <xsl:if test="$dialog/@name and $dialog/@name != ''">
              <xsl:value-of select="$dialog/@name"/>
            </xsl:if>
          </xsl:variable>
          <xsl:for-each select="$dialog/element">
            <xsl:choose>
              <xsl:when test="$horizontal = true() and search = false()">
                <xsl:call-template name="dialog-control-group">
                  <xsl:with-param name="line" select="." />
                  <xsl:with-param name="isElement" select="true()" />
                  <xsl:with-param name="showMandatory" select="$showMandatory" />
                  <xsl:with-param name="captions" select="$captions" />
                  <xsl:with-param name="controlNamePrefix" select="$controlNamePrefix" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="dialog-control-unit">
                  <xsl:with-param name="line" select="." />
                  <xsl:with-param name="isElement" select="true()" />
                  <xsl:with-param name="showMandatory" select="$showMandatory" />
                  <xsl:with-param name="captions" select="$captions" />
                  <xsl:with-param name="controlNamePrefix" select="$controlNamePrefix" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                  <xsl:with-param name="search" select="$search" />
                  <xsl:with-param name="placeholder" select="$search = true()" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </linegroup>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="$showButtons">
      <xsl:choose>
        <xsl:when test="$horizontal = true()">
          <div class="control-group">
            <div class="controls">
              <xsl:call-template name="dialog-buttons">
                <xsl:with-param name="dialog" select="$dialog" />
                <xsl:with-param name="submitButton" select="$submitButton" />
              </xsl:call-template>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$inline = false() and $search = false()"><br /></xsl:if>
          <xsl:call-template name="dialog-buttons">
            <xsl:with-param name="dialog" select="$dialog" />
            <xsl:with-param name="submitButton" select="$submitButton" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-buttons">
    <xsl:param name="dialog" />
    <xsl:param name="submitButton" select="false()" />
    <xsl:param name="horizontal" select="false()" />

    <xsl:for-each select="$dialog/*[name() = 'dlgbutton' or name() = 'button']">
      <xsl:call-template name="dialog-button">
        <xsl:with-param name="buttonType">
          <xsl:choose>
            <xsl:when test="@type != ''">
              <xsl:value-of select="@type" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text></xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="buttonName">
          <xsl:choose>
            <xsl:when test="@name != ''">
              <xsl:value-of select="@name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text></xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="buttonValue">
          <xsl:choose>
            <xsl:when test="@value and @value != ''">
              <xsl:value-of select="@value" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="node()" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$submitButton != false()">
      <xsl:call-template name="dialog-button">
        <xsl:with-param name="buttonName" select="'submit'" />
        <xsl:with-param name="buttonValue" select="$submitButton" />
        <xsl:with-param name="buttonType" select="'submit'" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-button">
    <xsl:param name="buttonName" select="''"/>
    <xsl:param name="buttonValue" select="''"/>
    <xsl:param name="buttonType" select="''"/>

    <button class="btn">
      <xsl:attribute name="type">
        <xsl:value-of select="$buttonType" />
      </xsl:attribute>
      <xsl:if test="$buttonName and $buttonName != ''">
        <xsl:attribute name="name">
          <xsl:value-of select="$buttonName" />
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$buttonValue"/>
    </button>
  </xsl:template>

  <xsl:template name="dialog-control-id">
    <xsl:param name="line" />
    <xsl:if test="$line">
      <xsl:choose>
        <xsl:when test="$line/input/@id"><xsl:value-of select="$line/input/@id" /></xsl:when>
        <xsl:when test="$line/input/@fid"><xsl:value-of select="$line/input/@fid" /></xsl:when>
        <xsl:when test="$line/select/@id"><xsl:value-of select="$line/select/@id" /></xsl:when>
        <xsl:when test="$line/select/@fid"><xsl:value-of select="$line/select/@fid" /></xsl:when>
        <xsl:when test="$line/textarea/@id"><xsl:value-of select="$line/textarea/@id" /></xsl:when>
        <xsl:when test="$line/textarea/@fid"><xsl:value-of select="$line/textarea/@fid" /></xsl:when>
        <xsl:when test="$line/@fid"><xsl:value-of select="$line/@fid" /></xsl:when>
        <xsl:when test="$line/@id"><xsl:value-of select="$line/@id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id($line)" /></xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-control-group">
    <xsl:param name="line" />
    <xsl:param name="isElement" select="false()" />
    <xsl:param name="showMandatory" select="true()" />
    <xsl:param name="captions" select="false()" />
    <xsl:param name="controlNamePrefix" select="''" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="termsText" select="false()" />

    <xsl:variable name="controlId">
      <xsl:call-template name="dialog-control-id">
         <xsl:with-param name="line" select="$line" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not($line/input[@type = 'hidden']) and not($line[@type = 'hidden'])">
        <div>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$showMandatory = true() and $line//@mandatory = 'true'">
                <xsl:text>control-group required</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>control-group</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <xsl:variable name="label">
            <xsl:choose>
              <xsl:when test="$termsText">
                <xsl:copy-of select="$termsText/node()" />
              </xsl:when>
              <xsl:when test="$line/@caption and $line/@caption != ''">
                <xsl:value-of select="$line/@caption" />
              </xsl:when>
              <xsl:when test="$line/label and $line/label/text() != ''">
                <xsl:value-of select="$line/label" />
              </xsl:when>
              <xsl:when test="$line/@title and $line/@title != ''">
                <xsl:value-of select="$line/@title" />
              </xsl:when>
              <xsl:when test="$captions and $captions/*[name() = $line/@name]">
                <xsl:value-of select="$captions/*[name() = $line/@name]" />
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$line/input[@type = 'radio'] and count($line/input[@type = 'radio']) &gt; 1">
              <label for="{$controlId}" class="control-label"><xsl:value-of select="$label" /></label>
            </xsl:when>
            <xsl:when test="not($line/input[@type = 'checkbox' or @type = 'radio']) and not($line[@type = 'checkbox' or @type = 'radio'])">
              <label for="{$controlId}" class="control-label"><xsl:value-of select="$label" /></label>
            </xsl:when>
          </xsl:choose>

          <div class="controls">
            <xsl:choose>
              <xsl:when test="$isElement = false()">
                <xsl:call-template name="dialog-control">
                  <xsl:with-param name="control" select="$line/*[name() = 'input' or name() = 'select' or name() = 'textarea']" />
                  <xsl:with-param name="controlId" select="$controlId" />
                  <xsl:with-param name="label" select="$label" />
                  <xsl:with-param name="image" select="$line/img" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                </xsl:call-template>
                <xsl:if test="$line/@hint != ''">
                  <span class="help-block"><xsl:value-of select="$line/@hint" /></span>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="dialog-control">
                  <xsl:with-param name="control" select="$line" />
                  <xsl:with-param name="controlId" select="$controlId" />
                  <xsl:with-param name="label" select="$label" />
                  <xsl:with-param name="namePrefix" select="$controlNamePrefix" />
                  <xsl:with-param name="inputSize" select="$inputSize" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$isElement = false()">
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line/input" />
              <xsl:with-param name="controlId" select="$controlId" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="namePrefix" select="$controlNamePrefix" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control-unit">
    <xsl:param name="line" />
    <xsl:param name="isElement" select="false()" />
    <xsl:param name="showMandatory" select="true()" />
    <xsl:param name="captions" select="false()" />
    <xsl:param name="controlNamePrefix" select="''" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="search" select="false()" />
    <xsl:param name="placeholder" select="false()" />

    <xsl:variable name="controlId">
      <xsl:call-template name="dialog-control-id">
         <xsl:with-param name="line" select="$line" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not($line/input[@type = 'hidden']) and not($line[@type = 'hidden'])">

        <xsl:variable name="label">
          <xsl:choose>
            <xsl:when test="$line/@caption and $line/@caption != ''">
              <xsl:value-of select="$line/@caption" />
            </xsl:when>
            <xsl:when test="$line/label and $line/label/text() != ''">
              <xsl:value-of select="$line/label" />
            </xsl:when>
            <xsl:when test="$line/@title and $line/@title != ''">
              <xsl:value-of select="$line/@title" />
            </xsl:when>
            <xsl:when test="$captions and $captions/*[name() = $line/@name]">
              <xsl:value-of select="$captions/*[name() = $line/@name]" />
            </xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="$placeholder = false()">
          <xsl:choose>
            <xsl:when test="$line/input[@type = 'radio'] and count($line/input[@type = 'radio']) &gt; 1">
              <label for="{$controlId}">
                <xsl:if test="$showMandatory">
                  <xsl:attribute name="class">required</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$label" />
              </label>
            </xsl:when>
            <xsl:when test="not($line/input[@type = 'checkbox' or @type = 'radio']) and not($line[@type = 'checkbox' or @type = 'radio'])">
              <label for="{$controlId}">
                <xsl:if test="$showMandatory">
                  <xsl:attribute name="class">required</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$label" />
              </label>
            </xsl:when>
          </xsl:choose>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$isElement = false()">
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line/*[name() = 'input' or name() = 'select' or name() = 'textarea']" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="label" select="$label" />
              <xsl:with-param name="image" select="$line/img" />
              <xsl:with-param name="inputSize" select="$inputSize" />
              <xsl:with-param name="search" select="$search" />
              <xsl:with-param name="placeholder" select="$placeholder" />
            </xsl:call-template>
            <xsl:if test="$line/@hint != ''">
              <span class="help-block"><xsl:value-of select="$line/@hint" /></span>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="label" select="$label" />
              <xsl:with-param name="namePrefix" select="$controlNamePrefix" />
              <xsl:with-param name="inputSize" select="$inputSize" />
              <xsl:with-param name="search" select="$search" />
              <xsl:with-param name="placeholder" select="$placeholder" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$isElement = false()">
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line/input" />
              <xsl:with-param name="controlId" select="$controlId" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dialog-control">
              <xsl:with-param name="control" select="$line" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="namePrefix" select="$controlNamePrefix" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($line)" />
    <xsl:param name="label" select="''" />
    <xsl:param name="image" select="false()" />
    <xsl:param name="namePrefix" select="''" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="search" select="false()" />
    <xsl:param name="placeholder" select="false()" />

    <xsl:variable name="name">
      <xsl:call-template name="dialog-control-name">
        <xsl:with-param name="name" select="$control/@name"/>
        <xsl:with-param name="prefix" select="$namePrefix"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$control[name() = 'textarea']">
        <xsl:call-template name="dialog-control-textarea">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="inputSize" select="$inputSize" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[name() = 'select']">
        <xsl:call-template name="dialog-control-select">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="inputSize" select="$inputSize" />
          <xsl:with-param name="label" select="$label" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[@type = 'file']">
        <xsl:call-template name="dialog-control-file">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="inputSize" select="$inputSize" />
        </xsl:call-template>
        <xsl:if test="$image/@src != ''">
          <br />
          <img>
            <xsl:attribute name="class">uploaded-image-file thumbnail</xsl:attribute>
            <xsl:attribute name="alt"></xsl:attribute>
            <xsl:copy-of select="$image/@*[name() != 'class' and name() != 'style']" />
          </img>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$control[@type = 'hidden']">
        <xsl:call-template name="dialog-control-hidden">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[@type = 'text']">
        <xsl:call-template name="dialog-control-input">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="inputSize" select="$inputSize" />
          <xsl:with-param name="search" select="$search" />
          <xsl:with-param name="placeholder" select="$placeholder" />
          <xsl:with-param name="label" select="$label" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[@type = 'password']">
        <xsl:call-template name="dialog-control-password">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="inputSize" select="$inputSize" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[@type = 'checkbox']">
        <xsl:call-template name="dialog-control-checkbox">
          <xsl:with-param name="control" select="$control" />
          <xsl:with-param name="controlId" select="$controlId" />
          <xsl:with-param name="name" select="$name" />
          <xsl:with-param name="label" select="$label" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$control[@type = 'radio']">
        <xsl:choose>
          <xsl:when test="count($control) &gt; 1">
            <xsl:call-template name="dialog-control-radio">
              <xsl:with-param name="control" select="$control" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="name" select="$name" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dialog-control-radio">
              <xsl:with-param name="control" select="$control" />
              <xsl:with-param name="controlId" select="$controlId" />
              <xsl:with-param name="name" select="$name" />
              <xsl:with-param name="label" select="$label" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control-name">
    <xsl:param name="name" />
    <xsl:param name="prefix" />
    <xsl:choose>
      <xsl:when test="$prefix and $prefix != ''">
        <xsl:value-of select="$prefix"/>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control-file">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="inputSize" select="false()" />

    <input type="file" name="{$name}">
      <xsl:copy-of select="$control/@*[name() = 'value' or name() = 'maxlength' or name() = 'size']" />
      <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
      <xsl:if test="$inputSize != false()">
        <xsl:attribute name="class">input-<xsl:value-of select="$inputSize" /></xsl:attribute>
      </xsl:if>
    </input>
  </xsl:template>

  <xsl:template name="dialog-control-hidden">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />

    <input type="hidden" name="{$name}">
      <xsl:copy-of select="$control/@*[name() = 'value']" />
      <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
    </input>
  </xsl:template>

  <xsl:template name="dialog-control-input">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="placeholder" select="false()" />
    <xsl:param name="search" select="false()" />
    <xsl:param name="label" select="''" />

    <input type="text" name="{$name}">
      <xsl:copy-of select="$control/@*[name() = 'value' or name() = 'maxlength' or name() = 'size' or name() = 'disabled']" />
      <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
      <xsl:if test="$control/text() and $control/text() != ''">
        <xsl:attribute name="value"><xsl:value-of select="$control/text()" /></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$inputSize != false()">
          <xsl:attribute name="class">
            input-<xsl:value-of select="$inputSize" />
            <xsl:if test="$search = true()"><xsl:text> </xsl:text>search-query</xsl:if>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$search = true()">
          <xsl:attribute name="class">search-query</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$inputSize != false()">
        <xsl:attribute name="class">input-<xsl:value-of select="$inputSize" /></xsl:attribute>
      </xsl:if>
      <xsl:if test="$placeholder = true()">
        <xsl:attribute name="placeholder"><xsl:value-of select="$label" /></xsl:attribute>
      </xsl:if>
    </input>
  </xsl:template>

  <xsl:template name="dialog-control-password">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="inputSize" select="false()" />

    <input type="password" name="{$name}">
      <xsl:copy-of select="$control/@*[name() = 'maxlength' or name() = 'size']" />
      <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
      <xsl:if test="$inputSize != false()">
        <xsl:attribute name="class">input-<xsl:value-of select="$inputSize" /></xsl:attribute>
      </xsl:if>
    </input>
  </xsl:template>

  <xsl:template name="dialog-control-checkbox">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="label" />
    <xsl:param name="checked" select="false()" />

    <label class="checkbox">
      <input type="checkbox" name="{$name}">
        <xsl:copy-of select="$control/@*[name() = 'value' or name() = 'checked']" />
        <xsl:if test="$checked">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
        <xsl:if test="$controlId != ''">
          <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
        </xsl:if>
      </input>
      <xsl:text> </xsl:text><xsl:copy-of select="$label" />
    </label>
  </xsl:template>

  <xsl:template name="dialog-control-radio">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="label" select="false()" />
    <xsl:param name="checked" select="false()" />

    <xsl:choose>
      <xsl:when test="count($control) &gt; 1">
        <xsl:for-each select="$control">
          <label class="radio">
            <input type="radio" name="{$name}">
              <xsl:copy-of select="$control/@*[name() = 'value' or name() = 'checked']" />
              <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
            </input>
            <xsl:text> </xsl:text><xsl:value-of select="." />
          </label>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <label class="radio">
          <input type="radio" name="{$name}">
            <xsl:copy-of select="$control/@*[name() = 'value' or name() = 'checked']" />
            <xsl:if test="$checked">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
          </input>
          <xsl:text> </xsl:text><xsl:value-of select="$label" />
        </label>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control-select">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="$control/@name" />
    <xsl:param name="inputSize" select="false()" />
    <xsl:param name="label" select="''" />

    <xsl:choose>
      <!-- support for new checkbox groups -->
      <xsl:when test="$control/@type = 'checkboxes'">
        <xsl:variable name="name" select="$control/@name" />
        <xsl:for-each select="$control/option">
          <xsl:call-template name="dialog-control-checkbox">
            <xsl:with-param name="control" select="." />
            <xsl:with-param name="controlId" select="''" />
            <xsl:with-param name="name"><xsl:value-of select="$name" />[]</xsl:with-param>
            <xsl:with-param name="label" select="./text()" />
            <xsl:with-param name="checked" select="@selected = 'selected'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <!-- support for new radio boxes -->
      <xsl:when test="$control/@type = 'radio'">
        <xsl:variable name="name" select="$control/@name" />
        <xsl:for-each select="$control/option">
          <xsl:call-template name="dialog-control-radio">
            <xsl:with-param name="control" select="." />
            <xsl:with-param name="controlId" select="''" />
            <xsl:with-param name="name"><xsl:value-of select="$name" /></xsl:with-param>
            <xsl:with-param name="label" select="./text()" />
            <xsl:with-param name="checked" select="@selected = 'selected'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <select name="{$name}">
          <xsl:copy-of select="$control/@*[name() = 'size' or name() = 'class']" />
          <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
          <xsl:if test="$inputSize != false()">
            <xsl:attribute name="class">input-<xsl:value-of select="$inputSize" /></xsl:attribute>
          </xsl:if>
          <xsl:for-each select="$control/option">
            <option>
              <xsl:copy-of select="@*" />
              <xsl:apply-templates select="./node()"/>
            </option>
          </xsl:for-each>
        </select>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-control-textarea">
    <xsl:param name="control" />
    <xsl:param name="controlId" select="generate-id($control)" />
    <xsl:param name="name" select="''" />
    <xsl:param name="inputSize" select="false()" />

    <textarea>
      <xsl:copy-of select="$control/@*[name() = 'name' or name() = 'class' or name() = 'rows' or name() = 'cols']" />
      <xsl:attribute name="id"><xsl:value-of select="$controlId"/></xsl:attribute>
      <xsl:if test="$inputSize != false()">
        <xsl:attribute name="class">input-<xsl:value-of select="$inputSize" /></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="$control/node()"/><xsl:text> </xsl:text>
    </textarea>
  </xsl:template>

</xsl:stylesheet>