TEXDIR := book/tex
RMD_CHAPTERS := $(shell find . -name '*.rmd' -depth 1)
TEX_CHAPTERS := $(patsubst ./%.rmd, $(TEXDIR)/%.tex, $(RMD_CHAPTERS))

all: book/ggplot2-book.pdf

book/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.pdf
	cp $(TEXDIR)/ggplot2-book.pdf book/ggplot2-book.pdf

# compile tex to pdf
$(TEXDIR)/ggplot2-book.pdf: $(TEXDIR)/ggplot2-book.tex $(TEXDIR)/krantz.cls $(TEX_CHAPTERS)
	mkdir -p $(TEXDIR)/figures && cp -r figures/* $(TEXDIR)/figures
	mkdir -p $(TEXDIR)/diagrams && cp -r diagrams/* $(TEXDIR)/diagrams
	cd $(TEXDIR) && latexmk -xelatex -use-make -interaction=batchmode ggplot2-book.tex

# copy over LaTeX templates and style files
$(TEXDIR)/krantz.cls:
	cp book/krantz.cls $(TEXDIR)/krantz.cls
$(TEXDIR)/ggplot2-book.tex: book/ggplot2-book.tex
	cp book/ggplot2-book.tex $(TEXDIR)/ggplot2-book.tex

# rmd -> tex
$(TEXDIR)/%.tex: %.rmd
	Rscript render-tex.R $<

$(TEXDIR):
	mkdir -p $(TEXDIR)

clean:
	rm -r $(TEXDIR)
	rm -r figures