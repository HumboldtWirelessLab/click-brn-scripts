<?xml version="1.0" encoding="UTF-8"?>
 <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
    <xsl:strip-space elements="*"/>
    <xsl:output method="text"/>


<!-- um bewegungsprofil zu erstellen und crashes zu ermitteln -->
<xsl:template match="gps_map">
<xsl:value-of select="@id"/>,<xsl:value-of select="@count"/><xsl:text>,</xsl:text>
<xsl:for-each select="node">
<xsl:value-of select="@mac"/><xsl:text>,</xsl:text>
</xsl:for-each>
<xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>