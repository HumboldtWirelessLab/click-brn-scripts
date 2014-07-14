<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name='newline'><xsl:text>

</xsl:text></xsl:variable>

	<xsl:key name="searchId" match="/simpleflow/topology_info" use="@extra_data" />
	
	<xsl:template match="/">
		<simpleflow>
			<xsl:apply-templates/>
		</simpleflow>
	</xsl:template>
	
	<xsl:template match="DibadawnStartSearch">
		<xsl:if test="@searchId = $search">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="SearchTree">
		<xsl:if test="@searchId = $search">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CrossEdgeDetected">
		<xsl:if test="@searchId = $search">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="topology_info">
		<xsl:if test="@extra_data = $search">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="dibadawn_config">
		<xsl:if test="@searchId = $search">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text( )|@*">
	  <!--<xsl:value-of select="."/>-->
	</xsl:template>

</xsl:stylesheet>
