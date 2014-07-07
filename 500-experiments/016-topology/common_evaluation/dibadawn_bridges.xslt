<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" indent="yes" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="concat('&quot;node_a&quot;', ',')" />
        <xsl:value-of select="'&quot;node_a&quot;'" />
        <xsl:value-of select="$newline" />

        <xsl:for-each select="simpleflow/Bridge[@src = 'self'] ">
            <xsl:value-of select="concat('&quot;', @nodeA, '&quot;', ',')" />
            <xsl:value-of select="concat('&quot;', @nodeB, '&quot;')" />
            <xsl:value-of select="$newline" />
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
