<?xml version='1.0'?>
<!-- Testing:
xsltproc run.xml Main\ Topic.mm | grep Here
-->	  
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" version='1.0'>  
<xsl:output omit-xml-declaration="yes" encoding="UTF-8"/>
<xsl:template match="map">
	<map>
	<xsl:apply-templates/>
</map>
</xsl:template>

<xsl:template match="node">
	<xsl:if test = "contains(current()/@LINK,'.mm') ">
		<!-- Extract filename with %20 instead whitespace -->
		<xsl:variable name="filename" select="@LINK"/>
		<xsl:variable name="filename1">
    		<xsl:call-template name="string-replace-all">
   	   	<xsl:with-param name="text" select="$filename" />
      		<xsl:with-param name="replace" select="' '" />
      		<xsl:with-param name="by" select="'%20'" />
    		</xsl:call-template>
 		 </xsl:variable>
		
		 <xsl:apply-templates select="document($filename1)//map"/>
		<!--<xsl:value-of select="$filename1" />-->
	</xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>
<xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
 </xsl:template>

 <!-- Replace function for xslt 1.0 -->
<xsl:template name="string-replace-all">
	<xsl:param name="text" />
   <xsl:param name="replace" />
   <xsl:param name="by" />
   <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

</xsl:stylesheet>

