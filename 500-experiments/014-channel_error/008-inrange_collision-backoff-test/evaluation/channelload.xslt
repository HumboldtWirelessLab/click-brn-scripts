<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
    
	<xsl:variable name='newline'><xsl:text>
	</xsl:text></xsl:variable>

    	<xsl:template match="text( )|@*">
      		<!--<xsl:value-of select="."/>-->
    	</xsl:template>

	<xsl:template match="/">
       		<xsl:apply-templates select="/evaluation"/> 
   	</xsl:template>
    	
	<xsl:template match="channelloadmeasurement">
        	<xsl:apply-templates />
    	</xsl:template>

    	<xsl:template match="channelstats">
        	<xsl:apply-templates />
    	</xsl:template>

    	<xsl:template match="neighbourstats">
        	<xsl:apply-templates />
    	</xsl:template>

    	<xsl:template match="nb">
        	<xsl:value-of select="../../../@num" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@no_nodes" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@packetsize" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@backoff" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@backoff_max" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@seed" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@rate" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../@time" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../@node" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../@id" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../phy/@hwbusy" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../phy/@hwrx" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../phy/@hwtx" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac/@rx_pkt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac/@crc_err_pkt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac/@phy_err_pkt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@addr" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@rssi" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@std_rssi" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@min_rssi" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@max_rssi" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@pkt_cnt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac/@rx_retry_pkt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac/@tx_retry_pkt" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac_percentage/@busy" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac_percentage/@rx" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../mac_percentage/@tx" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="@missed_seq" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../phy/@channel" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@ptktarget" /><xsl:text>,</xsl:text>
        	<xsl:value-of select="../../../@channelmodel" />
		<xsl:value-of select="$newline" />
        	<xsl:apply-templates />
    	</xsl:template>
</xsl:stylesheet>
