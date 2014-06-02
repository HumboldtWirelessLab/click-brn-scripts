<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text"/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/"> 
        <xsl:text>ID,Rate,Length,Replies</xsl:text>
        <xsl:value-of select="$newline" />
        
        <xsl:for-each select="simpleflow/flowstats/txflow">
            <xsl:value-of select="concat(@src, 'and', @dst)" />
            <xsl:text >,</xsl:text>
            <xsl:value-of select="substring-after(@extra_data, 'mcs_rate=')" />
            <xsl:text >,</xsl:text>
            <xsl:value-of select="@packet_size" />
            <xsl:text >,</xsl:text>
            <xsl:value-of select="@replies" />
            <xsl:value-of select="$newline" />
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
