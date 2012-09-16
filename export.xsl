<?xml version='1.0'?>
<!--
Released under GPL <http://www.gnu.org/licenses/>
Copyright and Authors: 2001 - 2012
 Joerg Feuerhake <joerg.feuerhake@free-penguin.org>
 Robert Ladstaetter <robert@ladstaetter.info>
 Igor G. Olaizola <igor.go@gmail.com>
 Uwe Ziegenhagen <webmaster@uweziegenhagen.de>
 Gerolf Ziegenhain <g@ziegenhain.com>


Testing: 
xsltproc export.xsl Main\ Topic.mm > test.tex && pdflatex test.tex && open test.pdf


See: http://freemind.sourceforge.net/


TODO:
* indented level 5 missing
* if all siblings have no child, use itemize
* follow links to other files
* convert arrows to references to text passages
-->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
<!--<xsl:output omit-xml-declaration="yes" encoding="ISO-8859-1"/>-->
<xsl:output omit-xml-declaration="yes" encoding="UTF-8"/>

<!-- Main tag -->
<xsl:template match="map">
	<xsl:text>
	\documentclass[ngerman]{scrreprt}
	\usepackage[utf8]{inputenc}
	\usepackage[]{babel}
	\usepackage[T1]{fontenc}
	\author{Tux}
	\title{</xsl:text><xsl:value-of select="node/@TEXT"/><xsl:text>}
	\begin{document}
	\maketitle
	\tableofcontents
	</xsl:text>
		<!-- Apply further templates, here... -->
		<xsl:apply-templates/>
	<xsl:text>
	\end{document}
	</xsl:text>
</xsl:template>

<!-- Process the nodes
Magic numbers:
* ancestor: 2 already exist in the main structure	  
-->
<xsl:template match="node">
	<xsl:if test="(count(ancestor::node())-2)=0">
		<xsl:apply-templates/>
	</xsl:if>

	<!--
	<xsl:if test="(count(child::node()))=0">
		<xsl:call-template name="itemization"></xsl:call-template>
	</xsl:if>
	-->

	<xsl:if test="(count(child::node()))>=0">
		<xsl:if test="(count(ancestor::node())-2)=1">
			<xsl:text>\chapter{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
		
		<xsl:if test="(count(ancestor::node())-2)=2">
			<xsl:text>\section{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
		
		
		<xsl:if test="(count(ancestor::node())-2)=3">
			<xsl:text>\subsection{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
			<xsl:apply-templates/>
		</xsl:if>	

		<xsl:if test="(count(ancestor::node())-2)=4">
			<xsl:text>\subsubsection{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
			<xsl:apply-templates/>
		</xsl:if>	

		<xsl:if test="(count(ancestor::node())-2)>4">
			<xsl:call-template name="itemization_sections"></xsl:call-template>
		</xsl:if>		
	</xsl:if>

	<xsl:if test = "contains(current()/@LINK,'.mm') ">
	<xsl:text>
		AJAJAJAJAJAJ 
	</xsl:text>
		<xsl:apply-templates select="document('Another Map.mm')"/>
      <xsl:apply-templates/>
		<!--<xsl:variable name="varValue" select="document('Another Map.mm')/map"/>
		<xsl:apply-templates select="$varValue" />	-->
<xsl:text>%</xsl:text><xsl:value-of select="@LINK"/>
<!--<xsl:variable name="doc2" select="document(current()/@LINK)" />-->
<!--	<xsl:value-of select="$doc2/map@VERSION"/>-->
<!--<xsl:value-of select="document('Another Map.mm')//map/node/@TEXT" />
<xsl:for-each select="document('Another Map.mm')//map/node/@TEXT">
   	<xsl:value-of select="."/>
   </xsl:for-each>
-->
	</xsl:if>

</xsl:template>

<!-- Itemization for subsections -->
<xsl:template name="itemization_sections">
	<xsl:param name="i" select="current()/node"/>
	<xsl:text>		\begin{itemize}</xsl:text>
	<xsl:for-each select="$i">
		<xsl:choose>
			<xsl:when test="@TEXT">
				<xsl:text>	\item </xsl:text><xsl:value-of select="@TEXT"/><xsl:text></xsl:text>
			</xsl:when>
			<xsl:when test="current()/richcontent/html/body/p/@text">
				<xsl:text>	\item </xsl:text><xsl:call-template name="richtext"></xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="current()/node">
			<xsl:call-template name="itemization_sections"></xsl:call-template>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>		\end{itemize}</xsl:text>
</xsl:template>


<!-- Itemization of Siblings-->
<xsl:template name="itemization">
		<xsl:text>		\begin{itemize}</xsl:text>
	<xsl:text>	\item </xsl:text><xsl:value-of select="@TEXT"/><xsl:text></xsl:text>
	<xsl:text>		\end{itemize}</xsl:text>
</xsl:template>


</xsl:stylesheet>

