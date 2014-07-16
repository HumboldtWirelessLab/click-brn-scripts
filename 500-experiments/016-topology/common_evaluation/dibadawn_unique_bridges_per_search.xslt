<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="yes" />

	<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

	<xsl:key name="bridge" match="/searches/search/topology_info/bridges/bridge" use="concat(../../@extra_data, @node_a, @node_b)" />

	<xsl:template match="/">
		<xsl:value-of select="concat('&quot;node_a&quot;', ',')" />
		<xsl:value-of select="'&quot;node_b&quot;'" />
		<xsl:value-of select="$newline" />

		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="bridge[generate-id() = generate-id(key('bridge', concat(../../@extra_data, @node_a, @node_b))[1])]">
		<xsl:value-of select="concat('&quot;', @node_a, '&quot;', ',')" />
		<xsl:value-of select="concat('&quot;', @node_b, '&quot;')" />
		<xsl:value-of select="$newline" />
	</xsl:template>

	<xsl:template match="text( )|@*">
		<!--<xsl:value-of select="."/>-->
	</xsl:template>

</xsl:stylesheet>
