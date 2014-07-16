<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" />

	<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
	
	<xsl:key name="node_key" match="/simpleflow/DibadawnLinkStat" use="@node" />

	<xsl:template match="/">
		<xsl:value-of select="'&quot;node_a&quot;,'" />
		<xsl:value-of select="'&quot;node_b&quot;,'" />
		<xsl:value-of select="'&quot;metric&quot;,'" />
		<xsl:value-of select="'&quot;rx_a_count&quot;,'" />
		<xsl:value-of select="'&quot;tx_a_count&quot;,'" />
		<xsl:value-of select="'&quot;rx_b_count&quot;,'" />
		<xsl:value-of select="'&quot;tx_b_count&quot;'" />
		<xsl:value-of select="$newline" />

		<!-- <xsl:for-each select="/simpleflow/DibadawnPacketRx/@node[generate-id() = generate-id(key('node_key', @node)[1])] "> -->
		<xsl:for-each select="/simpleflow/DibadawnLinkStat[generate-id() = generate-id(key('node_key', @node)[1])]">
			<xsl:variable name="node_a" select="@node" />
			<xsl:variable name="node_a_tx" select="tx/@num" />

			<xsl:for-each select="/simpleflow/DibadawnLinkStat[@node != $node_a and generate-id() = generate-id(key('node_key', @node)[1])]">
				<xsl:variable name="node_b" select="@node" />
				<xsl:variable name="node_b_tx" select="tx/@num" />
				<xsl:variable name="node_a_rx"> 
					<xsl:choose>
						<xsl:when test="/simpleflow/DibadawnLinkStat[@node = $node_a]/rx[@node = $node_b]">
							<xsl:value-of select="/simpleflow/DibadawnLinkStat[@node = $node_a]/rx[@node = $node_b]/@num" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="node_b_rx"> 
					<xsl:choose>
						<xsl:when test="/simpleflow/DibadawnLinkStat[@node = $node_b]/rx[@node = $node_a]">
							<xsl:value-of select="/simpleflow/DibadawnLinkStat[@node = $node_b]/rx[@node = $node_a]/@num" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:value-of select="concat('&quot;', $node_a, '&quot;', ',')" />
				<xsl:value-of select="concat('&quot;', $node_b, '&quot;', ',')" />

				<xsl:choose>
					<xsl:when test="$node_a_rx = 0 or $node_b_rx = 0 or $node_a_tx = 0 or $node_b_tx = 0">
						<xsl:value-of select="'&quot;99999&quot;,'" />
					</xsl:when>

					<xsl:otherwise>
					<xsl:variable name="metric" select="format-number(1 div (($node_b_rx div $node_a_tx) * ($node_a_rx div $node_b_tx)), '0.###')" />
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
