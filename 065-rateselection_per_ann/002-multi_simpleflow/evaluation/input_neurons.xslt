<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:key name="key_link" match="txflow" use="concat(@src, '+', @dst)"/>

    <xsl:template match="/">
        <data_set>
            <!-- for pair of (src,dest) -->
            <xsl:for-each select="simpleflow/flowstats/txflow[count(. | key('key_link', concat(@src, '+', @dst))[1]) = 1]">
                <xsl:variable name="src_addr" select="@src"/>
                <xsl:variable name="des_addr" select="@dst"/>

                <link>
                    <xsl:attribute name="from">
                        <xsl:value-of select="@src" />
                    </xsl:attribute>

                    <xsl:attribute name="to">
                        <xsl:value-of select="@dst" />
                    </xsl:attribute>

                    <!-- for each  occurrence of this pair -->
                    <xsl:for-each select="/simpleflow/flowstats[@node = $src_addr]/txflow[@dst = $des_addr]">
                        <xsl:sort select="@tx_rate" data-type="number" order="descending"/>
                        <xsl:if test="position() = 1">
                            <optimal_rate>
                                <xsl:attribute name="max_thruput">
                                    <xsl:value-of select="@tx_rate" />
                                </xsl:attribute>

                            <xsl:value-of select="@extra_data" />
                            </optimal_rate>
                        </xsl:if>
                    </xsl:for-each>
                </link>
            </xsl:for-each>
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

