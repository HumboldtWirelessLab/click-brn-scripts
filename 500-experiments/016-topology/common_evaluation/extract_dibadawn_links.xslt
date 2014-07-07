<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:key name="node_key" match="/simpleflow/*[self::DibadawnPacketRx | self::DibadawnPacketTx]" use="@node" />

    <xsl:template match="/">
        <xsl:value-of select="'&quot;node_a&quot;,'" />
        <xsl:value-of select="'&quot;node_b&quot;,'" />
        <xsl:value-of select="'&quot;metric&quot;,'" />
        <xsl:value-of select="'&quot;rx_a_count&quot;,'" />
        <xsl:value-of select="'&quot;tx_a_count&quot;'" />
        <xsl:value-of select="'&quot;rx_b_count&quot;,'" />
        <xsl:value-of select="'&quot;tx_b_count&quot;'" />
        <xsl:value-of select="$newline" />

        <!-- <xsl:for-each select="/simpleflow/DibadawnPacketRx/@node[generate-id() = generate-id(key('node_key', @node)[1])] "> -->
        <xsl:for-each select="/simpleflow/*[self::DibadawnPacketRx | self::DibadawnPacketTx][generate-id() = generate-id(key('node_key', @node)[1])]">
            <xsl:variable name="node_a" select="@node" />

            <xsl:for-each select="/simpleflow/*[self::DibadawnPacketRx | self::DibadawnPacketTx][@node != $node_a and generate-id() = generate-id(key('node_key', @node)[1])]">
                <xsl:variable name="node_b" select="@node" />
                <xsl:variable name="node_a_rx" select="count(/simpleflow/DibadawnPacketRx[@node = $node_a and @forwardedBy = $node_b and @type = 'true'])" />
                <xsl:variable name="node_a_tx" select="count(/simpleflow/DibadawnPacketTx[@node = $node_a and @type = 'true'])" />
                <xsl:variable name="node_b_rx" select="count(/simpleflow/DibadawnPacketRx[@node = $node_b and @forwardedBy = $node_a and @type = 'true'])" />
                <xsl:variable name="node_b_tx" select="count(/simpleflow/DibadawnPacketTx[@node = $node_b and @type = 'true'])" />
                
                <xsl:value-of select="concat('&quot;', $node_a, '&quot;', ',')" />
                <xsl:value-of select="concat('&quot;', $node_b, '&quot;', ',')" />

                <xsl:choose>
                    <xsl:when test="$node_a_rx = 0 ">
                        <xsl:value-of select="'&quot;99999&quot;,'" />
                    </xsl:when>

                    <xsl:otherwise>
                    <xsl:variable name="metric" select="1 div (($node_b_rx div $node_a_tx) * ($node_a_rx div $node_b_tx))" />
                    <xsl:value-of select="concat('&quot;',$metric,'&quot;', ',')" />
                </xsl:otherwise>
                </xsl:choose>
                
                <xsl:value-of select="concat('&quot;', $node_a_rx, '&quot;', ',')" />
                <xsl:value-of select="concat('&quot;', $node_a_tx, '&quot;', ',')" />
                <xsl:value-of select="concat('&quot;', $node_b_rx, '&quot;', ',')" />
                <xsl:value-of select="concat('&quot;', $node_b_tx, '&quot;')" />
                <xsl:value-of select="$newline" />

            </xsl:for-each>    

           
            
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
