TEXDIR := book/tex
RMD_CHAPTERS := $(shell find . -name '*.rmd')
TEX_CHAPTERS := $(patsubst ./%.rmd, $(TEXDIR)/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

book/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.pdf
	cp $(TEXDIR)/ggplot2-book.pdf book/ggplot2-book.pdf
	Rscript -e 'embedFonts("book/ggplot2-book.pdf")'
	
# compile tex to pdf
$(TEXDIR)/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.tex $(TEXDIR)/krantz.cls $(TEX_CHAPTERS)
	mkdir -p $(TEXDIR)/figures && cp -r figures/* $(TEXDIR)/figures
	mkdir -p $(TEXDIR)/tbls && cp -r tbls/* $(TEXDIR)/tbls
	mkdir -p $(TEXDIR)/diagrams && cp -r diagrams/* $(TEXDIR)/diagrams
	# http://stackoverflow.com/questions/3148492/makefile-silent-remove
	cd $(TEXDIR) && @rm ggplot2-book.ind 2> /dev/null || true
	cd $(TEXDIR) && @rm ggplot2-book.out 2> /dev/null || true
	cd $(TEXDIR) && xelatex ggplot2-book.tex
	cd $(TEXDIR) && makeindex ggplot2-book.idx
	cd $(TEXDIR) && xelatex ggplot2-book.tex 
	cd $(TEXDIR) && xelatex ggplot2-book.tex

# copy over LaTeX templates and style files
$(TEXDIR)/krantz.cls: book/krantz.cls $(TEXDIR)
	cp book/krantz.cls $(TEXDIR)/krantz.cls
$(TEXDIR)/ggplot2-book.tex: book/ggplot2-book.tex $(TEXDIR)
	cp book/ggplot2-book.tex $(TEXDIR)/ggplot2-book.tex

# rmd -> tex
$(TEXDIR)/%.tex: %.rmd
	Rscript render-tex.R $<

$(TEXDIR):
	mkdir -p $(TEXDIR)

clean:
	rm -r $(TEXDIR)
	rm -r tbls
	rm -r figures