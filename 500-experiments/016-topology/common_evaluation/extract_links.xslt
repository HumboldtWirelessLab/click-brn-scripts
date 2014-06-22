<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="concat('&quot;node_a&quot;', ',')" />
        <xsl:value-of select="concat('&quot;node_a&quot;', ',')" />
        <xsl:value-of select="'&quot;metric&quot;'" />
        <xsl:value-of select="$newline" />
        <xsl:for-each select="simpleflow/linktable/link[@to = ../@id] ">
            <xsl:value-of select="concat('&quot;', @from, '&quot;', ',')" />
            <xsl:value-of select="concat('&quot;', @to, '&quot;', ',')" />
            <xsl:value-of select="concat('&quot;', @metric, '&quot;')" />
            <xsl:value-of select="$newline" />
            
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
