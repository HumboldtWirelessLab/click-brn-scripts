<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="/channelstatsexp">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="channelstats">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="phy">
	<xsl:value-of select="../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@channel" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@num" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@rep" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwbusy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwrx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwtx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@busy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@tx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@avg_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@crc_rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@noerr_rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_duration/@phy_rx" /><xsl:value-of select="$newline" />
    </xsl:template>
    

</xsl:stylesheet>