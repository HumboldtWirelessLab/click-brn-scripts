<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:key name="key_link" match="rxflow[contains(@extra_data, 'mcs_rate')]" use="concat(@src, '+', @dst)"/>

    <xsl:template match="/">
        <data_set>
            <!-- for each pair of (src,dest) -->
            <xsl:for-each select="simpleflow/flowstats/rxflow[count(. | key('key_link', concat(@src, '+', @dst))[1]) = 1 and contains(@extra_data, 'mcs_rate')]">
                <xsl:variable name="src_addr" select="@src"/>
                <xsl:variable name="des_addr" select="@dst"/>

                <link>
                    <xsl:attribute name="from">
                        <xsl:value-of select="@src" />
                    </xsl:attribute>

                    <xsl:attribute name="to">
                        <xsl:value-of select="@dst" />
                    </xsl:attribute>

                    <number_of_neighbors>
                        <xsl:for-each select="/simpleflow/hiddennodedetection[@node = $src_addr]/neighbour_nodes">
                            <xsl:sort select="count(./node[@addr != 'FF-FF-FF-FF-FF-FF'])" data-type="number" order="descending"/>
                            <xsl:if test="position() = 1">
                                <xsl:value-of select="count(./node[@addr != 'FF-FF-FF-FF-FF-FF'])" />
                            </xsl:if>
                        </xsl:for-each>
                    </number_of_neighbors>

                    <number_of_hidden_nodes>
                        <xsl:value-of select="count(/simpleflow/hiddennodedetection[neighbour_nodes/node/@addr = $des_addr]/hidden_nodes/node[@addr = $src_addr])" />                        
                    </number_of_hidden_nodes>

                    <optimal_rate>
                        <!-- for each  occurrence of this pair -->
                        <xsl:for-each select="/simpleflow/flowstats[@node = $des_addr]/rxflow[@dst = $des_addr and contains(@extra_data, 'mcs_rate')]">
                            <xsl:sort select="@packet_count" data-type="number" order="descending"/>
                            <xsl:sort select="substring-after(@extra_data, 'mcs_rate=')" data-type="number" order="descending"/>
                            <xsl:if test="position() = 1">
                                <xsl:value-of select="substring-after(@extra_data, 'mcs_rate=')" />
                            </xsl:if>
                        </xsl:for-each>
                    </optimal_rate>

                    <rssi>
                        <xsl:for-each select="/simpleflow/entry[@from = $src_addr]/link[@to = $des_addr]/link_info">
                            <xsl:sort select="@fwd_min_rssi" data-type="number" order="ascending"/>
                            <xsl:if test="position() = 1">
                                <xsl:value-of select="@fwd_min_rssi" />
                            </xsl:if>
                        </xsl:for-each>
                    </rssi>
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
