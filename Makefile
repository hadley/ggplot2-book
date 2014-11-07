qplot.pdf: qplot.Rnw
	echo 'library(knitr); knit2pdf("qplot.Rnw")'|R --no-save
	rm -f *.aux *.bbl
