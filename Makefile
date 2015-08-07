TEXDIR := book/tex
RMD_CHAPTERS := $(shell ls ./*.rmd)
TEX_CHAPTERS := $(patsubst ./%.rmd, $(TEXDIR)/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

book/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.pdf
	cp $(TEXDIR)/ggplot2-book.pdf book/ggplot2-book.pdf

# compile tex to pdf
$(TEXDIR)/ggplot2-book.pdf: $(TEXDIR) $(TEXDIR)/ggplot2-book.tex $(TEXDIR)/krantz.cls $(TEX_CHAPTERS)
	cp -R _figures/* $(TEXDIR)/_figures
	cp -R diagrams/* $(TEXDIR)/diagrams
	cd $(TEXDIR) && latexmk -xelatex -interaction=batchmode ggplot2-book.tex

# copy over LaTeX templates and style files
$(TEXDIR)/krantz.cls: book/krantz.cls
	cp book/krantz.cls $(TEXDIR)/krantz.cls
$(TEXDIR)/ggplot2-book.tex: book/ggplot2-book.tex
	cp book/ggplot2-book.tex $(TEXDIR)/ggplot2-book.tex

$(TEXDIR)/%.tex: %.rmd toc.rds
	Rscript book/render-tex.R $<

toc.rds: $(RMD_CHAPTERS)
	Rscript -e "bookdown::index()"

$(TEXDIR):
	mkdir -p $(TEXDIR)
	mkdir -p $(TEXDIR)/_figures
	mkdir -p $(TEXDIR)/diagrams

clean:
	rm -rf $(TEXDIR)
	rm -rf _figures
	rm -rf _cache