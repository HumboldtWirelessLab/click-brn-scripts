<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="'&quot;articulation_point&quot;'" />
        <xsl:value-of select="$newline" />

        <xsl:for-each select="simpleflow/ArticulationPoint ">
            <xsl:value-of select="concat('&quot;', @node, '&quot;')" />
            <xsl:value-of select="$newline" />
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
