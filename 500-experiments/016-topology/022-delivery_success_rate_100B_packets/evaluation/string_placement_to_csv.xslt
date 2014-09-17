<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" indent="yes" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="concat('node',',')" />
        <xsl:value-of select="concat('distance',',')" />
        <xsl:value-of select="concat('received_packages', ',')" />
        <xsl:value-of select="concat('sample_size', ',')" />
        <xsl:value-of select="concat('packet_size', ',')" />
        <xsl:value-of select="'real_sent'" />
        <xsl:value-of select="$newline" />

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="flowstats/rxflow[../txflow/@extra_data != 'dont_use']">
        <xsl:variable name="packet_count"> 
            <xsl:choose>
                <xsl:when test="@packet_count > 0">
                    <xsl:value-of select="@packet_count" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="sample_size" select="count(/simpleflow/flowstats[@node='00-00-00-00-00-01']/txflow)" /> 

        <xsl:value-of select="concat(../@node, ',')" />
        <xsl:value-of select="concat(../txflow/@extra_data, ',')" />
        <xsl:value-of select="concat($packet_count, ',')" />
        <xsl:value-of select="concat($sample_size, ',')" />
        <xsl:value-of select="concat(@packet_size, ',')" />
        <xsl:value-of select="/simpleflow/flowstats[@node='00-00-00-00-00-01']/txflow/@packet_count" />
        <xsl:value-of select="$newline" />
    </xsl:template>

    <xsl:template match="text( )|@*">
        <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
