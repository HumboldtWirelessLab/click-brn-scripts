<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="mobilemeasurement">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="mobilestats">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="channelstats">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="rssi">
	<xsl:value-of select="../../gps/@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../gps/@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../gps/@lat" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../gps/@long" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../gps/@alt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../gps/@speed" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@node" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@rx_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@no_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@crc_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac/@phy_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_percentage/@busy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../mac_percentage/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@hwbusy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@hwrx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@avg_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@std_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@avg_rssi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@std_rssi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../phy/@channel" /><xsl:text>,00-00-00-00-00-00,0,0,0,0,0</xsl:text>
        <xsl:value-of select="$newline" />
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="nb">
	<xsl:value-of select="../../../gps/@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../gps/@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../gps/@lat" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../gps/@long" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../gps/@alt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../../gps/@speed" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@node" /><xsl:text>,</xsl:text>
        <xsl:value-of select="../../@time" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../@id" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac/@rx_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac/@no_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac/@crc_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac/@phy_err_pkt" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac_percentage/@busy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../mac_percentage/@rx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@hwbusy" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@hwrx" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@avg_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@std_noise" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@avg_rssi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@std_rssi" /><xsl:text>,</xsl:text>
	<xsl:value-of select="../../phy/@channel" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@addr" /><xsl:text>,</xsl:text>
        <xsl:value-of select="@rssi" /><xsl:text>,</xsl:text>
        <xsl:value-of select="@std_rssi" /><xsl:text>,</xsl:text>
        <xsl:value-of select="@max_rssi" /><xsl:text>,</xsl:text>
        <xsl:value-of select="@min_rssi" /><xsl:text>,</xsl:text>
        <xsl:value-of select="@pkt_cnt" />
        <xsl:value-of select="$newline" />
    </xsl:template>
    
</xsl:stylesheet>