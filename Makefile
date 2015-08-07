TEXDIR := book/tex
RMD_CHAPTERS := $(shell find . -depth 1 -name '*.rmd')
TEX_CHAPTERS := $(patsubst ./%.rmd, $(TEXDIR)/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

book/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.pdf
	cp $(TEXDIR)/ggplot2-book.pdf book/ggplot2-book.pdf

# compile tex to pdf
$(TEXDIR)/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.tex $(TEXDIR)/krantz.cls $(TEX_CHAPTERS)
	mkdir -p $(TEXDIR)/figures && cp -r figures/* $(TEXDIR)/figures
	mkdir -p $(TEXDIR)/diagrams && cp -r diagrams/* $(TEXDIR)/diagrams
	cd $(TEXDIR) && latexmk -xelatex -interaction=batchmode ggplot2-book.tex

# copy over LaTeX templates and style files
$(TEXDIR)/krantz.cls:
	cp book/krantz.cls $(TEXDIR)/krantz.cls
$(TEXDIR)/ggplot2-book.tex: book/ggplot2-book.tex
	cp book/ggplot2-book.tex $(TEXDIR)/ggplot2-book.tex

# rmd -> tex
$(TEXDIR)/%.tex: %.rmd toc.rds
	Rscript book/render-tex.R $<

toc.rds: $(RMD_CHAPTERS)
	Rscript -e "bookdown::index()"

$(TEXDIR):
	mkdir -p $(TEXDIR)

clean:
	rm -r $(TEXDIR)
	rm -r figures