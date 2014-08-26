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
        <xsl:text># int    - number of bridges time two (directed edged)</xsl:text><xsl:value-of select="$newline" />
        <xsl:text># int    - number of articulation points</xsl:text><xsl:value-of select="$newline" />
        <xsl:text># int    - number of timeouts </xsl:text><xsl:value-of select="$newline" />
        
        <xsl:text>result,</xsl:text>
        <xsl:choose>
            <xsl:when test="//DibadawnPacketTx[@node != ./forwardedBy]">0,</xsl:when>
            <xsl:otherwise >1,</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="count(//DibadawnPacketTx) = count(//DibadawnPacketRx)">1,</xsl:when>
            <xsl:otherwise >0,</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="count(/simpleflow/topology_info/bridges/bridge)" /><xsl:text>,</xsl:text>
        <xsl:value-of select="count(/simpleflow/topology_info/articulationpoints/articulationpoint)" /><xsl:text>,</xsl:text>
        <xsl:value-of select="count(/simpleflow/ForwardTimeout)" /><xsl:text>,</xsl:text>
        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:text># List of all bridges</xsl:text><xsl:value-of select="$newline" />
        <xsl:text>bridges,</xsl:text>
        <xsl:for-each select="/simpleflow/topology_info/bridges/bridge" >
            <xsl:value-of select="concat(@node_a, '--', @node_b, ',')" />
        </xsl:for-each>
        <xsl:value-of select="$newline" />
        <xsl:value-of select="$newline" />

        <xsl:text># List of all aarticulation points</xsl:text><xsl:value-of select="$newline" />
        <xsl:text>articulationpoints,</xsl:text>
        <xsl:for-each select="/simpleflow/topology_info/articulationpoints/articulationpoint" >
            <xsl:value-of select="concat(@node, ',')" />
        </xsl:for-each>
        <xsl:value-of select="$newline" />
    </xsl:template>

</xsl:stylesheet>

