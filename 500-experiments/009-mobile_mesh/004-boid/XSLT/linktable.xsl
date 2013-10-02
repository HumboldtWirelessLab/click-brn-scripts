<?xml version="1.0" encoding="UTF-8"?>
 <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
    <xsl:strip-space elements="*"/>
    <xsl:output method="text"/>

<xsl:template match="linktable">
<xsl:variable name="time" select="@time"/>
<xsl:variable name="name" select="@id"/>
<xsl:for-each select="link">
<xsl:if test="@from = $name">
<xsl:value-of select="$time"/>,<xsl:value-of select="@from"/>,<xsl:value-of select="@to"/>,<xsl:value-of select="@metric"/><xsl:text>
</xsl:text>
</xsl:if>
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>