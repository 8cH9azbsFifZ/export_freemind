<?xml version='1.0'?>
<!--
Released under GPL <http://www.gnu.org/licenses/>
Copyright and Authors: 2001 - 2012
 Joerg Feuerhake <joerg.feuerhake@free-penguin.org>
 Robert Ladstaetter <robert@ladstaetter.info>
 Igor G. Olaizola <igor.go@gmail.com>
 Uwe Ziegenhagen <webmaster@uweziegenhagen.de>
 Gerolf Ziegenhain <g@ziegenhain.com>


xsltproc export.xsl test.mm 

See: http://freemind.sourceforge.net/
-->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
<!--<xsl:output omit-xml-declaration="yes" encoding="ISO-8859-1"/>-->
<xsl:output omit-xml-declaration="yes" encoding="UTF-8"/>

<xsl:template match="map">
	<xsl:text>
	\documentclass[ngerman]{scrreprt}
	\usepackage[utf8]{inputenc}
	\usepackage[]{babel}
	\usepackage[T1]{fontenc}
	\author{Uwe Ziegenhagen}
	\title{</xsl:text><xsl:value-of select="node/@TEXT"/><xsl:text>}
	\begin{document}
	\maketitle
	\tableofcontents
	</xsl:text>

		<xsl:apply-templates/>

	<xsl:text>
	\end{document}
	</xsl:text>
</xsl:template>

<!-- ======= Body ====== -->
<!-- Sections Processing -->

<xsl:template match="richcontent">
</xsl:template>

<!-- Follow links -->

<xsl:template match="node">

	<xsl:if test="(count(ancestor::node())-2)=0">
		<xsl:apply-templates/>
	</xsl:if>

		
	<xsl:if test="(count(ancestor::node())-2)=1">
		<xsl:text>\chapter{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>
		<xsl:if test="current()/richcontent/html/body/img">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:if>
	
	<xsl:if test="(count(ancestor::node())-2)=2">
		<xsl:text>\section{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>
		<xsl:if test="current()/richcontent/html/body/img">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:if>
	
	
	<xsl:if test="(count(ancestor::node())-2)=3">
		<xsl:text>\subsection{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>
		<xsl:if test="current()/richcontent/html/body/img">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:if>	

	<xsl:if test="(count(ancestor::node())-2)=4">
		<xsl:text>\subsubsection{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>
		<xsl:if test="current()/richcontent/html/body/img">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:if>		
	

	<xsl:if test="(count(ancestor::node())-2)=5">
		<xsl:text>\paragraph{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>
		<xsl:if test="current()/richcontent/html/body/img">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:if>		
	

	<xsl:if test="(count(ancestor::node())-2)=6">
		<xsl:text>\subparagraph{</xsl:text><xsl:value-of select="@TEXT"/><xsl:text>}&#xD;</xsl:text>
			<!--We look if there are images in the frame in order to put columns or not-->
			<!--<xsl:if test="current()/node/richcontent/html/body">
				<xsl:text> Note detected</xsl:text>
			</xsl:if>-->
			<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
				<xsl:call-template name="richtext"></xsl:call-template>
			</xsl:if>
			<!-- <xsl:if test="current()/node/richcontent/html/body/p/@text"> -->
				<xsl:call-template name="itemization"></xsl:call-template>
			<!-- </xsl:if> -->
		<xsl:apply-templates/>
	</xsl:if>
</xsl:template>

<xsl:template name="itemization">
	<xsl:param name="i" select="current()/node"/>
	<xsl:text>		\begin{itemize}&#xD;</xsl:text>
	<xsl:for-each select="$i">
		<xsl:choose>
			<xsl:when test="@TEXT">
				<xsl:text>	\item </xsl:text><xsl:value-of select="@TEXT"/><xsl:text>&#xD;</xsl:text>
			</xsl:when>
			<xsl:when test="current()/richcontent/html/body/p/@text">
				<xsl:text>	\item </xsl:text><xsl:call-template name="richtext"></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="current()/node">
			<xsl:call-template name="itemization"></xsl:call-template>
		</xsl:if>
		<xsl:text>
		</xsl:text>	
	</xsl:for-each>

	<!--<xsl:if test="current()/richcontent">
			<xsl:call-template name="figures"></xsl:call-template>
		</xsl:if>-->
	<xsl:text>		\end{itemize}&#xD;</xsl:text>
</xsl:template>

<!-- template to parse and insert rich text (html, among <p> in Latex \item-s -->
<xsl:template name="richtext">
	<xsl:param name="i" select="current()/richcontent/html/body/p"/>
	<xsl:for-each select="$i">
		<xsl:text>&#xD; 
		&#xD;</xsl:text>
		<xsl:value-of select="normalize-space(translate(.,'&#x0d;&#x0a;', '  '))"/>
	</xsl:for-each>
</xsl:template>
			
<!-- template to parse and insert figures -->
<xsl:template name="figures">
	<xsl:text>
		\includegraphics[width=1.0\textwidth]{</xsl:text><xsl:value-of 
			select="current()/node/richcontent/html/body/img/@src"/><xsl:text>}
	</xsl:text>
</xsl:template>
<!-- template to parse and insert figures with manually edited html. (inside <p>)-->
<xsl:template name="figuresp">
	<xsl:text>
		\includegraphics[width=1.0\textwidth]{</xsl:text><xsl:value-of 
			select="current()/node/richcontent/html/body/p/img/@src"/><xsl:text>}
	</xsl:text>
</xsl:template>

<!--We look if there are images in the frame in order to put columns or not-->
				<!--<xsl:if test="current()/node/richcontent/html/body">
					<xsl:text> Note detected</xsl:text>
				</xsl:if>-->


<xsl:template match="text">
   <Notes><xsl:value-of select="text"/></Notes>
 </xsl:template>



<!-- End of LaTeXChar template -->

</xsl:stylesheet>

