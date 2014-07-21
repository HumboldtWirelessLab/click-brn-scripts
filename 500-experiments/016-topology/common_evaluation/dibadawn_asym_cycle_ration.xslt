<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" indent="yes" />

	<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
	
	<xsl:template match="/">
		<xsl:value-of select="concat('&quot;asym_cycle&quot;', ',')" />
		<xsl:value-of select="'&quot;all_cycles&quot;'" />
		<xsl:value-of select="$newline" />
		

		<xsl:value-of select="count(/simpleflow/CrossEdgeDetected[@valid = 0])" />
		<xsl:value-of select="','" />
		<xsl:value-of select="count(/simpleflow/CrossEdgeDetected)" />
		<xsl:value-of select="$newline" />

	</xsl:template>

	<xsl:template match="text( )|@*">
		<!--<xsl:value-of select="."/>-->
	</xsl:template>

</xsl:stylesheet>
