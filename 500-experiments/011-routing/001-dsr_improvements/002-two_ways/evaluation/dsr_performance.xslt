<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="/flooding_experiment">
	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="source">
	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="event">
	<xsl:apply-templates />
    </xsl:template>

    <xsl:template match="src">
	<xsl:value-of select="../../../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@seq" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@count" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@count" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@id" /><xsl:value-of select="$newline" />

	<xsl:apply-templates />
    </xsl:template>
</xsl:stylesheet>