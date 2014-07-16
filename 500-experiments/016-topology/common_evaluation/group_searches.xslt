<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name='newline'><xsl:text>

</xsl:text></xsl:variable>

	<xsl:key name="search" match="/simpleflow/topology_info" use="@extra_data" />
	
	<xsl:template match="/">
		<searches>
			<xsl:for-each select="/simpleflow/topology_info[generate-id() = generate-id(key('search', @extra_data)[1])]">
				<xsl:variable name='searchId' select='@extra_data' />

				<search>
					<xsl:for-each select="key('search', $searchId)">
						<xsl:copy-of select="."/>		
					</xsl:for-each>
				</search>
				
			</xsl:for-each>
		</searches>
	</xsl:template>
	
	<xsl:template match="text( )|@*">
	  <!--<xsl:value-of select="."/>-->
	</xsl:template>

</xsl:stylesheet>
