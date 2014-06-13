<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
        <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="/"><xsl:text/>
        <xsl:text># string - 'result' start flag</xsl:text><xsl:value-of select="$newline" />
        <xsl:text># bool   - 1 if forwardedBy == DibadawnPacketTx/@node else 0 </xsl:text><xsl:value-of select="$newline" />
        <xsl:text># bool   - 1 if count(DibadawnPacketTx) == count(DibadawnPacketRx) else 0 </xsl:text><xsl:value-of select="$newline" />
        <xsl:text>result,</xsl:text>
        <xsl:choose>
            <xsl:when test="//DibadawnPacketTx[@node != ./forwardedBy]">0,</xsl:when>
            <xsl:otherwise >1,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="count(//DibadawnPacketTx) = count(//DibadawnPacketRx)">1,</xsl:when>
            <xsl:otherwise >0,</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline" />
    </xsl:template>

</xsl:stylesheet>
