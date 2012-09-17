#!/bin/sh
infile=$1
tmp=1.xml
tmp1=test.tex
xsltproc combine.xsl $1 > $tmp
xsltproc export.xsl $tmp > $tmp1
pdflatex $tmp1
pdflatex $tmp1
