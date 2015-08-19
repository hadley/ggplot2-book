TEXDIR := book/tex
RMD_CHAPTERS := $(shell ls ./*.rmd)
TEX_CHAPTERS := $(patsubst ./%.rmd, $(TEXDIR)/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

# compile tex to pdf
book/ggplot2-book.pdf: $(TEXDIR) $(TEXDIR)/ggplot2-book.tex book/CHAPTERS
	cp -R book/springer/* $(TEXDIR)
	cp book/latexmk $(TEXDIR)/
	cp book/latexmkrc $(TEXDIR)/
	cd $(TEXDIR) && ./latexmk -xelatex -interaction=batchmode ggplot2-book.tex
	cp $(TEXDIR)/ggplot2-book.pdf book/ggplot2-book.pdf

book/CHAPTERS: $(TEX_CHAPTERS)
	cp -R _figures/* $(TEXDIR)/_figures
	cp -R diagrams/* $(TEXDIR)/diagrams
	# strip bad ICC metadata
	find $(TEXDIR) -type f -name "*.png" -exec optipng -strip all -o0 -clobber -quiet {} \;
	touch book/CHAPTERS

$(TEXDIR)/%.tex: %.rmd
	Rscript book/render-tex.R $<

$(TEXDIR)/ggplot2-book.tex: book/ggplot2-book.tex
	cp book/ggplot2-book.tex $(TEXDIR)/ggplot2-book.tex

$(TEXDIR):
	mkdir -p $(TEXDIR)
	mkdir -p $(TEXDIR)/_figures
	mkdir -p $(TEXDIR)/diagrams

clean:
	rm -rf $(TEXDIR)
	rm -rf _figures
	rm -rf _cache
	rm -rf *.html
	rm -rf *.pdf
	rm -rf book/ggplot2-book.pdf