# ggplot2 book

[![Build Status](https://travis-ci.org/hadley/ggplot2-book.png?branch=master)](https://travis-ci.org/hadley/ggplot2-book)

This is code and text behind the [ggplot2](http://ggplot2.org/book/) book. Please help us make it better by [contributing](https://github.com/hadley/ggplot2-book/blob/master/contributing.md)!

## Build the book

You can build the pdf by cloning this repo and running make:

```
$ git clone https://github.com/hadley/ggplot2-book.git
$ cd ggplot2-book
$ make
```

If you use RStudio, you can press Cmd/Ctrl + Shift + B to run make.

## Installing dependencies

To successfully build this book, you'll need R [package development prerequisites](https://support.rstudio.com/hc/en-us/articles/200486498-Package-Development-Prerequisites), [pandoc and pandoc-citeproc](http://pandoc.org/installing.html), potentially the [Inconsolata font](http://www.ctan.org/tex-archive/fonts/inconsolata/), and a number of R packages. The CRAN packages we depend on are listed in the DESCRIPTION, so you can install them quickly via [devtools](http://cran.r-project.org/web/packages/devtools/):

```r
devtools::install_deps("path/to/ggplot2-book", dependencies = TRUE)
```

There are also a couple GitHub packages which we depend on:

```r
devtools::install_github(c("adletaw/captioner", "hadley/bookdown"))
```

## Internal links

To link between sections, use internal links of the form `#header-id`.
All header references are listed in `toc.yaml`.
