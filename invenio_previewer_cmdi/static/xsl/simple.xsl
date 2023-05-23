<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmd="http://www.clarin.eu/cmd/"
	        xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes" />

  <xsl:template match="/">
    <html>
      <h1><xsl:value-of select="//*[local-name()='ResourceTitle']" /></h1>
    <p>
      <xsl:value-of select="//*[local-name()='Organisation']/*[local-name()='name']" />
    </p>
    </html>
  </xsl:template>
</xsl:stylesheet>
