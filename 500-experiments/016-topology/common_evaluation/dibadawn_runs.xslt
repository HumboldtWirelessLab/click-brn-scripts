<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" />

    <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:value-of select="'&quot;num_of_runs&quot;'" />
        <xsl:value-of select="$newline" />

        <xsl:value-of select="count(/simpleflow/DibadawnStartSearch)" />
        <xsl:value-of select="$newline" />
    </xsl:template>

    <xsl:template match="text( )|@*">
      <!--<xsl:value-of select="."/>-->
    </xsl:template>

</xsl:stylesheet>
