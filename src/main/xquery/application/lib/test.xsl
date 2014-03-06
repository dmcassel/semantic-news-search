<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
<result>Document from XSLT:
  <xsl:copy-of select="doc('content/news/world-asia-china-23081653.xml')"/>
</result>
  </xsl:template>
</xsl:stylesheet>