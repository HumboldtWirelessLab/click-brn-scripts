<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="htrates/htrate/rate">
      <!-- is ht (1). TODO: use mode -->
        <xsl:text>1,</xsl:text>
	<xsl:value-of select="../@ht40" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@sgi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@mcs_index" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@rate" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@psr" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@achivable_rate" /><xsl:value-of select="$newline" />
    </xsl:template>

    <xsl:template match="nonhtrates/rate">
      <!-- is non ht (0). TODO: use mode (a,b,g) -->
        <xsl:text>0,</xsl:text>
	<xsl:value-of select="@ht40" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@sgi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@mcs_index" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@rate" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@psr" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@achivable_rate" /><xsl:value-of select="$newline" />
    </xsl:template>

</xsl:stylesheet>