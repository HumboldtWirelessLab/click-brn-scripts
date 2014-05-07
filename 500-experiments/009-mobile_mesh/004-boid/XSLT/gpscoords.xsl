<?xml version="1.0" encoding="UTF-8"?>
 <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
    <xsl:strip-space elements="*"/>
    <xsl:output method="text"/>

<xsl:template match="gps">
<xsl:value-of select="@time"/>,<xsl:value-of select="@id"/>,<xsl:value-of select="@x"/>,<xsl:value-of select="@y"/><xsl:text>
</xsl:text>
</xsl:template>

</xsl:stylesheet>