<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="mobilegps">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="gps">
	<xsl:value-of select="@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@lat" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@long" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@alt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@speed" />
        <xsl:value-of select="$newline" />
        <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>