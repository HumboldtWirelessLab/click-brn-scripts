<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='text'/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="/map_info">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="dhcpleases">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="client">
	<xsl:value-of select="@ip" /><xsl:text>,</xsl:text>
	<xsl:value-of select="@mac" /><xsl:text>,</xsl:text>
        <xsl:variable name="node_id"><xsl:value-of select="@mac" />
        </xsl:variable>
	<xsl:value-of select="../../reversearptable/entry[@mac = $node_id]/@ip" /><xsl:value-of select="$newline" />
    </xsl:template>
</xsl:stylesheet>