<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
	
	<xsl:template match="/">
		<simpleflow>
			<xsl:for-each select="/simpleflow/DibadawnLinkStat">
				<xsl:copy-of select="."/>	
			</xsl:for-each>
		</simpleflow>
	</xsl:template>
	
	<xsl:template match="text( )|@*">
	  <!--<xsl:value-of select="."/>-->
	</xsl:template>

</xsl:stylesheet>
