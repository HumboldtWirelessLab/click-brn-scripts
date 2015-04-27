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

    <xsl:template match="neighbourstats">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="nb">
	<xsl:value-of select="../../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@channel" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@num" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@rep" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@addr" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@rssi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@pkt_cnt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@rx_bytes" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@duration" /><xsl:value-of select="$newline" />
    </xsl:template>
    

</xsl:stylesheet>