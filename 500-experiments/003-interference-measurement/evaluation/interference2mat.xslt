<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="/interference_experiment">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="source">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="pre_flow">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="during_flow">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="post_flow">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="channelstats">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="phy">
	<xsl:value-of select="../../../@seq" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@node_a" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../@node_b" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../during_flow_stats/interferencegraphflow/@rate" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../during_flow_stats/interferencegraphflow/@queue_empty_cnt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@channel" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwbusy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwrx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@hwtx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@busy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@tx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@avg_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@crc_rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@noerr_rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@phy_rx" /><xsl:text>,</xsl:text>
        <xsl:variable name="node_id"><xsl:value-of select="../@node" />
        </xsl:variable>
	<xsl:value-of select="../../../during_flow/system[@id = $node_id]/loadavg/@onemin" /><xsl:value-of select="$newline" />
    </xsl:template>
    

</xsl:stylesheet>