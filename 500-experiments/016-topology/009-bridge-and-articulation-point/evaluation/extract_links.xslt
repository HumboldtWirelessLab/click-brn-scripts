<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="concat('&quot;node_a&quot;,', '&quot;node_b&quot;', $newline)" />
        <xsl:for-each select="simpleflow/linktable/link ">
            <xsl:value-of select="concat('&quot;', @from, '&quot;,', '&quot;', @to, '&quot;', $newline)" />
            
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
