<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="acommunity-content-paging">
    <xsl:param name="paging" />
    <xsl:param name="parentAnchor" />

    <xsl:if test="$paging/@count &gt; 0">
      <div class="pagination">
        <ul>
          <xsl:for-each select="$paging/page">
            <li>
              <xsl:if test="@selected">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="@href" />
                  <xsl:if test="not($parentAnchor = '')">
                    <xsl:text>#</xsl:text><xsl:value-of select="$parentAnchor" />
                  </xsl:if>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@type and @type = 'first'">
                    <xsl:text>&#171;&#171;</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type and @type = 'previous'">
                    <xsl:text>&#171;</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type and @type = 'next'">
                    <xsl:text>&#187;</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type and @type = 'last'">
                    <xsl:text>&#187;&#187;</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@number" />
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>