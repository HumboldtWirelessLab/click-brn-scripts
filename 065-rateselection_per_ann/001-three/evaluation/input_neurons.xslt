<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <data_set>
            <xsl:apply-templates/>
        </data_set>
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

    <xsl:template match="nb" >
        <link>
            <xsl:attribute name="from">
                <xsl:value-of select="../../@node" />
            </xsl:attribute>

            <xsl:attribute name="to">
                <xsl:value-of select="@addr" />
            </xsl:attribute>

            <number_of_neighbors>
                <xsl:value-of select="count(../nb)" />
            </number_of_neighbors>

            <number_of_hidden_nodes>
                <xsl:variable name="from_node" select="../../@node" />
                <xsl:value-of select="count(../../../hiddennodedetection[@node=$from_node]/hidden_nodes/node)" />
            </number_of_hidden_nodes>

            <optimal_rate>
                
            </optimal_rate>

            <rssi>
                <xsl:value-of select="@rssi" />
            </rssi>
        </link>
    </xsl:template>

</xsl:stylesheet>

