RMD_CHAPTERS := $(shell find . -name '*.rmd')
TEX_CHAPTERS := $(patsubst %.rmd, book/tex/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

book/ggplot2-book.pdf: book/tex/ggplot2-book.pdf
	cp book/tex/ggplot2-book.pdf book/ggplot2-book.pdf
	Rscript -e 'embedFonts("book/ggplot2-book.pdf")'
	
# compile tex to pdf
# http://stackoverflow.com/questions/3148492/makefile-silent-remove
book/tex/ggplot2-book.pdf: book/tex/ggplot2-book.tex book/tex/krantz.cls book/tex/diagrams book/tex/tbls book/tex/figures
	cd book/tex && @rm ggplot2-book.ind 2> /dev/null || true
	cd book/tex && @rm ggplot2-book.out 2> /dev/null || true
	cd book/tex && xelatex ggplot2-book.tex
	cd book/tex && makeindex ggplot2-book
	cd book/tex && xelatex ggplot2-book.tex 
	cd book/tex && xelatex ggplot2-book.tex
	
# copy over stuff the book depends on
book/tex/figures: figures/
	cp -r figures book/tex/figures
book/tex/tbls: tbls/
	cp -r tbls book/tex/tbls
book/tex/diagrams: diagrams/
	cp -r diagrams book/tex/diagrams
	
# copy over LaTeX templates and style files
book/tex/krantz.cls: book/krantz.cls
	cp book/krantz.cls book/tex/krantz.cls
book/tex/ggplot2-book.tex: book/ggplot2-book.tex
	cp book/ggplot2-book.tex book/tex/ggplot2-book.tex

# rmd -> tex
$(TEX_CHAPTERS): $(RMD_CHAPTERS)
	Rscript render-tex.R $?