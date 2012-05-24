<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="measurement">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="channelstats">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="phy">
	<xsl:value-of select="../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@rx_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_percentage/@busy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_percentage/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwbusy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwrx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@channel" />
        <xsl:value-of select="$newline" />
        <xsl:apply-templates />
    </xsl:template>
    
</xsl:stylesheet>