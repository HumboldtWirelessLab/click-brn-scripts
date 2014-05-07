<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="tos2queuemapper">
	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="queueusage">
	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="queue">
	<xsl:value-of select="../../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@index" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@usage" /><xsl:text>,</xsl:text>
	<xsl:value-of select="$result"/><xsl:value-of select="$newline" />

	<xsl:apply-templates />
    </xsl:template>
</xsl:stylesheet>